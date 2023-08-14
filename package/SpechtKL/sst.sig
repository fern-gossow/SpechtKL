166,0
T,SSTableau,-,0
A,SSTableau,2,Tab,Range
S,SST,Create a semistandard tableau with designated range,0,2,0,0,0,0,0,0,0,148,,0,0,300,,SSTableau,-38,-38,-38,-38
S,SST,Create a semistandard tableau with range = number of boxes,0,1,0,0,0,0,0,0,0,300,,SSTableau,-38,-38,-38,-38
S,SST,Create a SST with prescribed range,1,0,1,82,1,82,0,148,2,0,0,0,0,0,0,0,148,,0,0,82,,SSTableau,-38,-38,-38,-38
S,SST,Create a SST with range = number of boxes,1,0,1,82,1,82,0,148,1,0,0,0,0,0,0,0,82,,SSTableau,-38,-38,-38,-38
S,SST,Create a SST with prescribed range given its skew shape,2,0,1,82,0,148,1,1,82,1,82,0,148,3,0,0,0,0,0,0,0,148,,0,0,82,,0,0,82,,SSTableau,-38,-38,-38,-38
S,SST,Create a SST given its skew shape with range = number of boxes,2,0,1,82,0,148,1,1,82,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,82,,SSTableau,-38,-38,-38,-38
S,RowReadingTableau,Return the row reading tableau of given shape,1,0,1,82,0,148,1,0,0,0,0,0,0,0,82,,SSTableau,-38,-38,-38,-38
S,ColumnReadingTableau,Return the column reading tableau of given shape,1,0,1,82,0,148,1,0,0,0,0,0,0,0,82,,SSTableau,-38,-38,-38,-38
S,Rows,Return the rows of T,0,1,0,0,0,0,0,0,0,SSTableau,,82,-38,-38,-38,-38
S,Range,Return the range of T,0,1,0,0,0,0,0,0,0,SSTableau,,148,-38,-38,-38,-38
S,Shape,Return the shape of T,0,1,0,0,0,0,0,0,0,SSTableau,,82,-38,-38,-38,-38
S,SkewShape,Return the skew shape of T,0,1,0,0,0,0,0,0,0,SSTableau,,82,-38,-38,-38,-38
S,IsSkew,Return whether T is a skew tableau,0,1,0,0,0,0,0,0,0,SSTableau,,36,-38,-38,-38,-38
S,Weight,"Return the crystal weight, i.e. content of T",0,1,0,0,0,0,0,0,0,SSTableau,,82,-38,-38,-38,-38
S,IsStandard,"Return whether the tableau is standard, nonskew, and has the correct range",0,1,0,0,0,0,0,0,0,SSTableau,,36,-38,-38,-38,-38
S,Conjugate,Return the conjugate of the tableau,0,1,0,0,0,0,0,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,RowReadingWord,"Return the row-reading word of T, from bottom-to-top and left-to-right",0,1,0,0,0,0,0,0,0,SSTableau,,82,-38,-38,-38,-38
S,eq,Check equality. Tableaux must have same range to be equal,0,2,0,0,0,0,0,0,0,SSTableau,,0,0,SSTableau,,36,-38,-38,-38,-38
S,Print,Print T at level L,0,2,0,0,1,0,0,0,0,298,,0,0,SSTableau,,-38,-38,-38,-38,-38
S,+,Compose two skew tableaux by joining them together,0,2,0,0,0,0,0,0,0,SSTableau,,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,JeuDeTaquin,"Perform jdt, and record the vacated cell",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTableau,,SSTableau,148,148,-38,-38
S,InverseJeuDeTaquin,"Perform inverse jdt, and record the vacated cell",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTableau,,SSTableau,148,148,-38,-38
S,Rectify,"Rectify T, and record the vacated rows and columns",0,1,0,0,0,0,0,0,0,SSTableau,,SSTableau,82,82,-38,-38
S,InverseRectify,Unrectify T along a given path,2,1,1,82,0,148,2,1,82,0,148,3,0,0,0,0,0,0,0,82,,0,0,82,,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,Evacuation,"Perform usual evacuation for tableaux, and reversal for skew tableaux",0,1,0,0,0,0,0,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,Restrict,"Restrict T to the boxes a,..,b",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,Restrict,Decompose T into skew parts according to a composition,1,1,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,SSTableau,,82,-38,-38,-38,-38
S,Restrict,Decompose T into skew parts according to a subset of generators,1,1,1,83,0,148,2,0,0,0,0,0,0,0,83,,0,0,SSTableau,,82,-38,-38,-38,-38
S,Evacuation,"Act on T by the cactus involution corresponding to I=[a,b]",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,Evacuation,Act on T by the cactus involution corresponding to a composition,1,1,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,Evacuation,Act on T by the cactus involution corresponding to a parabolic,1,1,1,83,0,148,2,0,0,0,0,0,0,0,83,,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,Promotion,Calculate the Scchützenberger promotion of T,0,1,0,0,0,0,0,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,NestedEvacuation,Calculate the nested evacuation of T,0,1,0,0,0,0,0,0,0,SSTableau,,SSTableau,-38,-38,-38,-38
S,IsKnuthEquivalent,"Determine whether two tableaux are Knuth equivalent, i.e. slides get from one to the other",0,2,0,0,0,0,0,0,0,SSTableau,,0,0,SSTableau,,36,-38,-38,-38,-38
S,IsDualEquivalent,"Determine whether two tableaux are dual equivalent, i.e. connected in their tableau crystal",0,2,0,0,0,0,0,0,0,SSTableau,,0,0,SSTableau,,36,-38,-38,-38,-38
S,HighestWeight,Return the highest weight of the crystal component connected to T,0,1,0,0,0,0,0,0,0,SSTableau,,82,-38,-38,-38,-38
S,HighestWeight,"Return the highest weight of the component connected to T of the crystal restricted to [a,b]",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTableau,,82,-38,-38,-38,-38
S,HighestWeight,Return the list of highest weights for connected components of T corresponding to a composition,1,1,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,SSTableau,,82,-38,-38,-38,-38
S,HighestWeight,Return the list of highest weights for connected components of T corresponding to a parabolic,1,1,1,83,0,148,2,0,0,0,0,0,0,0,83,,0,0,SSTableau,,82,-38,-38,-38,-38
S,PartitionDominanceLoE,Determine dominance order on two partitions,2,0,1,82,0,148,1,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,82,,36,-38,-38,-38,-38
S,HighestWeightLoE,Check dominance order for tableaux weights,0,2,0,0,0,0,0,0,0,SSTableau,,0,0,SSTableau,,36,-38,-38,-38,-38
S,HighestWeightLoE,"Check dominance order for tableaux weights with respect to the interval [a,b]",0,4,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTableau,,0,0,SSTableau,,36,-38,-38,-38,-38
S,HighestWeightLoE,Check dominance order for tableaux weights with respect to a composition,1,2,1,82,0,148,3,0,0,0,0,0,0,0,82,,0,0,SSTableau,,0,0,SSTableau,,36,-38,-38,-38,-38
S,HighestWeightLoE,Check dominance order for tableaux weights with respect to a parabolic,1,2,1,83,0,148,3,0,0,0,0,0,0,0,83,,0,0,SSTableau,,0,0,SSTableau,,36,-38,-38,-38,-38
S,InverseRSK,Compute the permutation which gives this pair under RSK,0,2,0,0,0,0,0,0,0,SSTableau,,0,0,SSTableau,,82,-38,-38,-38,-38
S,SetOfSYT,Create the set of standard tableaux with given shape,1,0,1,82,0,148,1,0,0,0,0,0,0,0,82,,83,-38,-38,-38,-38
S,SetOfSSYT,Create the set of semistandard tableaux with given shape and range,1,0,1,82,0,148,2,0,0,0,0,0,0,0,148,,0,0,82,,83,-38,-38,-38,-38
S,SetOfSSYT,Create the set of semistandard tableaux with given shape and content,2,0,1,82,0,148,1,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,82,,83,-38,-38,-38,-38
S,DualEquivalenceClass,Return the set of tableaux dual equivalent to T,0,1,0,0,0,0,0,0,0,SSTableau,,83,-38,-38,-38,-38
S,DualEquivalenceClassStandard,Return the set of standard skew tableaux dual equivalent to T,0,1,0,0,0,0,0,0,0,SSTableau,,83,-38,-38,-38,-38
