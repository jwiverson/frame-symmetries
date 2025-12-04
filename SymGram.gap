LoadPackage("grape");

SymGram:=function(G)
	#Input:		A square matrix G with constant diagonal
	#Output:	The group of permutations whose corresponding matrices commute
	#			with G.
	#Note:		In case G is the Gram matrix of a frame, the resulting
	#			permutation group is its automorphism group
	#Code written by Joseph W. Iverson
	
	local n,entries,i,j,first,e,graph,H,K;
	
	n:=Size(G);;
	
	#find the distinct off-diagonal entries
	entries:=[];;
	for i in [1..n] do
	for j in [1..n] do
		if i<>j then
			AddSet(entries,G[i][j]);
		fi;
	od;
	od;
	
	#make a graph for each entry, and intersect automorphism groups
	first:=true;
	for j in [1..Size(entries)-1] do
		e:=entries[j];
		graph:=Graph( Group(()), [1..n], OnPoints, function(x,y) return x<>y and G[x][y]=e; end, true );
		
		if IsNullGraph(graph) or IsCompleteGraph(graph) then
			#automorphism group is all of S_n
			#and intersecting makes no difference
			continue;
		fi;
		
		if first then
			#this is the first group considered
			H:=AutomorphismGroup(graph);
			first:=false;
		else
			#intersect with the previous group
			K:=AutomorphismGroup(graph);
			H:=Intersection(H,K);
		fi;
	od;
	
	#note: we do not need to consider the last entry, since the automorphisms that preserve all the previous graphs must also preserve the final graph
	
	if first then
		#only null or complete graphs appeared
		return SymmetricGroup(n);
	else
		return H;
	fi;
end;;