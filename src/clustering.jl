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


    orderCluster = [sum(Clustermatrix,dims=2) Clustermatrix]
    orderedCluster = sortslices(orderCluster,dims = 1, rev=true)
    reorderedCluster = orderedCluster[:,2:DSMsize+1]

    Order = [];

    for i = 1 : DSMsize
        Order = [Order ; findall(x-> x == 1 , reorderedCluster[i,:])]
    end

    ## reorder DSM
    I =zeros(DSMsize,DSMsize) + Diagonal(ones(DSMsize,DSMsize))
    P =zeros(DSMsize,DSMsize) + Diagonal(ones(DSMsize,DSMsize))
    Clusteredlabel = copy(original_label)
    copylabel= copy(original_label)

    ## Permutation matrix
    for i = 1 : DSMsize
        P[i,:] = I[Order[i],:]
        Clusteredlabel[i] = copylabel[Order[i]]
    end

    ## order DSM
    ClusteredDSM = P*original_DSM*P'

    return ClusteredDSM, Clusteredlabel;


end
