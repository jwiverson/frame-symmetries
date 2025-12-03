symp:=function(G)
	#Input:		The Gram matrix G of an equiangular tight frame
	#Output:	The projective symmetry group
	#Note:		We implement the algorithm of Shayne Waldron and Tuan-Yow Chien from "The projective symmetry group of a finite frame" (https://doi.org/10.53733/35)
	#This code was written by Joseph W. Iverson (https://www.jwiverson.com)

	local n, Flags, k, newFlags, flag, In, Out, m, copyIn, copyOut, broke, i, j, si, sj, sk, perms,gens,D,GG,L;

	n:=DimensionsMat(G)[1]; #the number of frame vectors

	Flags:=[]; #a list of flags that meet necessary conditions for growing
	AddSet(Flags,Immutable([ [], [1..n] ])); #begin with the empty flag

	for k in [1..n] do #k is the length of the flags under current consideration

		newFlags:=[];

		for flag in Flags do

			In:=flag[1]; #the flag as it currently stands; an immutable object
			Out:=flag[2]; #the elements of [1..n] not yet in the flag; an immutable object

			for m in [1..Length(Out)] do

				#make a candidate flag that adds the missing digit Out[m] to the end

				copyIn:=ShallowCopy(In); #a mutable copy, which can be changed without mangling the original
				copyOut:=ShallowCopy(Out);

				Add(copyIn,Out[m]);
				Remove(copyOut,m);

				#now test the candidate flag [copyIn,copyOut] for possible membership in newFlags

				broke:=false; #an indicator that the candidate flag is no good

				for i in [1..k-1] do

					for j in [i+1..k-1] do

						si:=copyIn[i]; #the image of i under the permutation associated with the candidate flag
						sj:=copyIn[j];
						sk:=copyIn[k];

						if not(G[i][j]*G[j][k]*G[k][i] = G[si][sj]*G[sj][sk]*G[sk][si]) then #candidate flag is no good

							broke:=true;
							break; #no need for further tests
						fi;			

					od;

					if broke = true then #candidate flag is no good, so there is no need to test any further

						break;

					fi;

				od;

				if broke = false then #candidate flag was okay!

					AddSet(newFlags,Immutable([copyIn,copyOut]));

				fi;

			od;

		od;

		Flags:=newFlags;

	od;

	perms:=List(Flags,flag->flag[1]); #a list of ALL permutations in the projective symmetry group


	#extract generators

	gens:=List( perms, list->PermList(list) );

	D:= AsSSortedList( gens );;
    	GG:= TrivialSubgroup( GroupByGenerators( gens ) );;
    	L:= ShallowCopy( D );;
    	SubtractSet( L, AsSSortedList( GG ) );;
    	while not IsEmpty(L)  do
    	    GG := ClosureGroupDefault( GG, L[1] );;
    	    SubtractSet( L, AsSSortedList( GG ) );;
    	od;
    	GG := GroupByGenerators( GeneratorsOfGroup( GG ), One( D[1] ) );;
    	SetAsSSortedList( GG, D );;
    	SetIsFinite( GG, true );;
    	SetSize( GG, Length( D ) );;

	return GG;

end;