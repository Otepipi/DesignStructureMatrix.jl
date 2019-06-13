module DesignStructureMatrix

using Gadfly
using LinearAlgebra

export plotDSM
export toReachableMatrix
export OrderReachable
export Sequencing
export Clustering

## plot DSM
function plotDSM(DSM,label)

    cDSM = copy(DSM);
nokonoko1
    cDSM[diagind(cDSM)] .= -1
    
     spy(cDSM, Scale.y_discrete(labels = i->label[i]), Scale.x_discrete(labels = i->label[i]),
        Guide.ylabel(nothing), Guide.xlabel(nothing, orientation=:vertical), Guide.xticks(orientation=:vertical),
        Scale.color_continuous(colormap=Scale.lab_gradient( "darkgrey","aliceblue", "navy")),
        Theme(minor_label_font_size=16pt, key_position=:none, bar_spacing= 0.5mm, panel_fill="darkgrey"))
    
end

## convert DSM to ReachableMatrix
function toReachableMatrix(DSM)

    I = zeros(Int64,size(DSM)) + Diagonal(ones(Int64,size(DSM))); #単位行列の生成

    calcmax = 1000

    for i  = 1 : calcmax
        

       global R1 = (DSM+I)^i
        (Rindex) =findall(x-> 1<x , R1);
        R1[Rindex] = ones(size(Rindex)); #ブール演算のかわり

        R2 = (DSM+I)^(i+1)
        (Rindex) =findall(x-> 1<x , R2);
        R2[Rindex] = ones(size(Rindex)); #ブール演算のかわり

        if R1 == R2
            break
        end
  
    end

    return R1
end


##order Reachable matrix for seaqencing
function OrderReachable(Reachable)

    original = copy(Reachable);
    (DSMsize,) = size(Reachable);
    valuesDSM = collect(1:DSMsize);
    count = 0;
    level = zeros(Int,DSMsize);
    
    while count < DSMsize
        
        R = Reachable;
        A = Reachable';
        RA = R .* A;
        (RAsize,) = size(RA);
        elements = collect(1:RAsize);
    
        for i = 1 : RAsize
            
            if RA[i,:] == R[i,:];
                    count += 1;
                    level[count] = valuesDSM[i];
                    elements[i] = 0;
            end
        end
    
        elements = filter(x-> x > 0, elements);
        Reachable = Reachable[elements , elements];
        valuesDSM = valuesDSM[elements];
    
    end
    
    orderedReachable = original[level,level]
    
    return orderedReachable , level
    
end

    ## Sequencing DSM
function Sequencing(DSM,label)
    cDSM = copy(DSM);
    clabel = copy(label);
    
    Reachable = toReachableMatrix(cDSM);

    (OrderedReachable,level) = OrderReachable(Reachable);

    SequencedDSM = cDSM[level,level];
    Sequencedlabel = clabel[level];

    return SequencedDSM, Sequencedlabel

end

##Clustering DSM
function Clustering(DSM,label)

    powcc = 1;
    powbid = 0;
    powdep = 1;
    rand_accept = 30;
    rand_bid = 30;
    times = 5;
    stable_limit = 2;
    
    original_DSM = copy(DSM);
    original_label = copy(label);
    (DSMsize,) = size(original_DSM);
    
    Clustermatrix = zeros(Int64,DSMsize,DSMsize) + Diagonal(ones(Int64,DSMsize,DSMsize)) ;
    
    cDSM = copy(original_DSM);
    
    
    function ClusterBid(Clustermatrix,cDSM,DSMsize,powdep,powbid,element)
    
        bestCluster = 0;
        bestBid = -1;
    
        for i = 1 : DSMsize
    
            Clusterlist= findall(x-> x == 1 , Clustermatrix[i,:]);
            (Clustersize,) = size(Clusterlist);
            bid = 0;
    
            for j = 1 : Clustersize
    
                bid += cDSM[element,Clusterlist[j]];
    
            end
    
            bid = bid ^ powdep / Clustersize ^ powbid;
    
            if bid > bestBid
    
                 bestBid = bid;
                bestCluster = i;
            end
    
        end
    
    
        return bestCluster
    
    end
    
    function TCC(cDSM,DSMsize,Clustermatrix,powcc)
    
        intraCost=0;
        extraCost=0;
    
    
        for i = 1: DSMsize
        
            for j = 1 : DSMsize
    
                Clusterofi = findall(x-> x == 1 , Clustermatrix[:,i]);
                Clusterofj = findall(x-> x == 1 , Clustermatrix[:,j]);
                (Clustersizeofi,) = size(Clustermatrix[Clusterofi,:]);
    
                cost = cDSM[i,j] + cDSM[j,i];
    
                if Clusterofi == Clusterofj
    
                    intraCost += cost*Clustersizeofi^powcc;
    
                else
    
                    extraCost += cost*DSMsize^powcc;
                end
    
    
            end
        
        end
    
        totalCost = intraCost + extraCost;
    
        return totalCost
    end
    
    
    TCCost = TCC(cDSM,DSMsize,Clustermatrix,powcc)
    
    costlist = zeros(DSMsize*times,1);
    
    for i = 1 : DSMsize * times;
    
        preClustermatrix = Clustermatrix;
        element = rand(1:DSMsize);
        bestCluster = ClusterBid(Clustermatrix,cDSM,DSMsize,powdep,powbid,element);
        Clustermatrix[:,element] = zeros(DSMsize,1);
        Clustermatrix[bestCluster,element] = 1;
        newCost = TCC(cDSM,DSMsize,Clustermatrix,powcc);
        if newCost <= maximum([TCCost,rand_accept])
            TCCost = newCost;
        else
            Clustermatrix = preClustermatrix;
        end
    
        costlist[i] = newCost
    end
    
    Clustermatrix
    costlist'
    
    orderCluster = [sum(Clustermatrix,dims=2) Clustermatrix]
    orderedCluster = sortslices(orderCluster,dims = 1, rev=true)
    reorderedCluster = orderedCluster[:,2:DSMsize+1]
    
    Order = [];
    
    for i = 1 : DSMsize
        Order = [Order ; findall(x-> x == 1 , reorderedCluster[i,:])]
    end
    
    I =zeros(DSMsize,DSMsize) + Diagonal(ones(DSMsize,DSMsize)) #単位行列の作成
    P =zeros(DSMsize,DSMsize) + Diagonal(ones(DSMsize,DSMsize)) #置換行列の作成 
    Clusteredlabel = copy(original_label) #ラベルも並べ替える
    copylabel= copy(original_label)
    
    for i = 1 : DSMsize
        P[i,:] = I[Order[i],:]
        Clusteredlabel[i] = copylabel[Order[i]]
    end
    
    ClusteredDSM = P*original_DSM*P' 
    
    return ClusteredDSM, Clusteredlabel;


end



end # module
