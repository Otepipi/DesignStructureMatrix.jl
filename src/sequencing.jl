

## convert DSM to ReachableMatrix
function toReachableMatrix(DSM)

    I = zeros(Int64,size(DSM)) + Diagonal(ones(Int64,size(DSM))); #identity matrix
    R1 = zeros(Int64,size(DSM))
    calcmax = 1000

    for i  = 1 : calcmax


        R1 = (DSM+I)^i
        (Rindex) =findall(x-> 1<x , R1);
        R1[Rindex] = ones(size(Rindex));

        R2 = (DSM+I)^(i+1)
        (Rindex) =findall(x-> 1<x , R2);
        R2[Rindex] = ones(size(Rindex));

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
