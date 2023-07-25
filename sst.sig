166,0
T,SSTab,-,0
A,SSTab,2,Tab,Weight
S,SST,Create a semistandard tableau with designated weight,0,2,0,0,0,0,0,0,0,148,,0,0,300,,SSTab,-38,-38,-38,-38
S,SST,Create a semistandard tableau with designated weight,0,1,0,0,0,0,0,0,0,300,,SSTab,-38,-38,-38,-38
S,SST,Create a SST with prescribed weight,1,0,1,82,1,82,0,148,2,0,0,0,0,0,0,0,148,,0,0,82,,SSTab,-38,-38,-38,-38
S,SST,Create a SST with weight = number of boxes,1,0,1,82,1,82,0,148,1,0,0,0,0,0,0,0,82,,SSTab,-38,-38,-38,-38
S,SST,Create a SST with prescribed weight given its skew shape,2,0,1,82,0,148,1,1,82,1,82,0,148,3,0,0,0,0,0,0,0,148,,0,0,82,,0,0,82,,SSTab,-38,-38,-38,-38
S,SST,Create a SST given its skew shape with weight = number of boxes,2,0,1,82,0,148,1,1,82,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,82,,SSTab,-38,-38,-38,-38
S,Print,Print T,0,1,0,0,1,0,0,0,0,SSTab,,-38,-38,-38,-38,-38
S,+,Compose two skew tableaux by joining them together,0,2,0,0,0,0,0,0,0,SSTab,,0,0,SSTab,,SSTab,-38,-38,-38,-38
S,Weight,Return the weight of T,0,1,0,0,0,0,0,0,0,SSTab,,148,-38,-38,-38,-38
S,Shape,Return the shape of T,0,1,0,0,0,0,0,0,0,SSTab,,82,-38,-38,-38,-38
S,SkewShape,Return the skew shape of T,0,1,0,0,0,0,0,0,0,SSTab,,82,-38,-38,-38,-38
S,IsSkew,Return whether T is a skew tableau,0,1,0,0,0,0,0,0,0,SSTab,,37,-38,-38,-38,-38
S,Rows,Return the rows of T,0,1,0,0,0,0,0,0,0,SSTab,,82,-38,-38,-38,-38
S,JeuDeTaquin,"Perform jdt, and record the vacated cell",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTab,,SSTab,148,148,-38,-38
S,InverseJeuDeTaquin,"Perform inverse jdt, and record the vacated cell",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTab,,SSTab,148,148,-38,-38
S,Rectify,"Rectify T, and record the vacated rows and columns",0,1,0,0,0,0,0,0,0,SSTab,,SSTab,82,82,-38,-38
S,InverseRectify,Unrectify T along a path,2,1,1,82,0,148,2,1,82,0,148,3,0,0,0,0,0,0,0,82,,0,0,82,,0,0,SSTab,,SSTab,-38,-38,-38,-38
S,Evacuation,"Perform usual evacuation for tableaux, and reversal for skew tableaux",0,1,0,0,0,0,0,0,0,SSTab,,SSTab,-38,-38,-38,-38
S,Restrict,"Restrict T to the boxes a,..,b",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTab,,SSTab,-38,-38,-38,-38
S,Decompose,Decompose T into skew parts according to parts,1,1,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,SSTab,,82,-38,-38,-38,-38
S,CactusInvolution,"Act on T by the cactus involution corresponding to I=[a,b]",0,3,0,0,0,0,0,0,0,148,,0,0,148,,0,0,SSTab,,SSTab,-38,-38,-38,-38
S,Promotion,Calculate the Scchützenberger promotion of T,0,1,0,0,0,0,0,0,0,SSTab,,SSTab,-38,-38,-38,-38
