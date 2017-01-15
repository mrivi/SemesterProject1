function [dist]=LSHminhash(tf1,tf2)

if (length(tf1)==length(tf2))
    ll=length(tf1); 
else
    error('should be same length');
end
        
        words={uint32(tf1) uint32(tf2)};
        %fprintf('Creating and searching a Min-Hash LSH index\n');
        ntables = 3;
        nfuncs = 2;
        dist = 'jac';

        % create and insert
        lsh = ccvLshCreate(ntables, nfuncs, 'min-hash', dist, 0, 0, 0, 2);
        ccvLshInsert(lsh, words, 0);

        format short
        % search for first two
        [ids dist] = ccvLshKnn(lsh, words, words(2), 2, dist);

        % clear
        ccvLshClean(lsh);
end
