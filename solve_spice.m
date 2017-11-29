numFreq = size(freq,2);
zFreq = zeros(cvolts,cvolts,numFreq);
rhs_list = zeros(numNodes,cvolts,numFreq);
lhs_list = zeros(numNodes,cvolts,numFreq);
spice_list = zeros(numNodes,numNodes,numFreq);

for freqind = 1:numFreq
    omega = 2*pi*freq(freqind); 
    spice_matrix = sparse(numNodes,numNodes);lhs = zeros(numNodes,cvolts);
    spice_matrix_perturbed = sparse(numNodes,numNodes);
    for j = 1:cres
        if(res(j).node1 == 0)
            if(res(j).node2 == 0)
            else
                spice_matrix(res(j).node2,res(j).node2) = spice_matrix(res(j).node2,res(j).node2) + (1/(res(j).val + (sqrt(-1)*omega*ind(j).val)));
            end
        else if(res(j).node2 == 0)
                if(res(j).node1 == 0)
                else
                    spice_matrix(res(j).node1,res(j).node1) = spice_matrix(res(j).node1,res(j).node1) + (1/(res(j).val+(sqrt(-1)*omega*ind(j).val)));
                end
            else
                spice_matrix(res(j).node1,res(j).node1) = spice_matrix(res(j).node1,res(j).node1) + (1/(res(j).val+(sqrt(-1)*omega*ind(j).val))); 
                spice_matrix(res(j).node1,res(j).node2) = spice_matrix(res(j).node1,res(j).node2) + (-1/(res(j).val+(sqrt(-1)*omega*ind(j).val)));             
                spice_matrix(res(j).node2,res(j).node1) = spice_matrix(res(j).node2,res(j).node1) + (-1/(res(j).val+(sqrt(-1)*omega*ind(j).val)));
                spice_matrix(res(j).node2,res(j).node2) = spice_matrix(res(j).node2,res(j).node2) + (1/(res(j).val+(sqrt(-1)*omega*ind(j).val)));

            end
        end 
    end
    for j = 1:ccap
        if(cap(j).node1 == 0)
            if(cap(j).node2 == 0)
            else
                spice_matrix(cap(j).node2,cap(j).node2) = spice_matrix(cap(j).node2,cap(j).node2) + ((omega*con(j).val)+(sqrt(-1)*omega*cap(j).val));
            end
        else if(cap(j).node2 == 0)
                if(cap(j).node1 == 0)
                else
                    spice_matrix(cap(j).node1,cap(j).node1) = spice_matrix(cap(j).node1,cap(j).node1) + ((omega*con(j).val)+(sqrt(-1)*omega*cap(j).val));
                end
            else
                spice_matrix(cap(j).node1,cap(j).node1) = spice_matrix(cap(j).node1,cap(j).node1) + ((omega*con(j).val)+(sqrt(-1)*omega*cap(j).val)); 
                spice_matrix(cap(j).node1,cap(j).node2) = spice_matrix(cap(j).node1,cap(j).node2) + -1*((omega*con(j).val)+(sqrt(-1)*omega*cap(j).val));             
                spice_matrix(cap(j).node2,cap(j).node1) = spice_matrix(cap(j).node2,cap(j).node1) + -1*((omega*con(j).val)+(sqrt(-1)*omega*cap(j).val));
                spice_matrix(cap(j).node2,cap(j).node2) = spice_matrix(cap(j).node2,cap(j).node2) + ((omega*con(j).val)+(sqrt(-1)*omega*cap(j).val));

            end
        end 
    end
    for j = 1:cvolts
        rhs = zeros(numNodes,1);
        rhs(volts(j).node1) = volts(j).val;

        tempinv = inv(spice_matrix);
        if(Con == 0)
        else
            if(volts(j).node2 == 0)
            else
               rhs(volts(j).node2) = -volts(j).val; 
            end
        end

        lhs(:,j) = inv(spice_matrix)*rhs;
        for ja = 1:cvolts
            zFreq(ja,j,freqind) = lhs(volts(ja).node1,j);
        end

    end


end


