166,0
T,SSTab,-,0
A,SSTab,2,Tab,Weight
S,SST,Create a SST with prescribed weight,1,0,1,82,1,82,0,148,2,0,0,0,0,0,0,0,148,,0,0,82,,SSTab,-38,-38,-38,-38
S,SST,Create a SST with weight = number of boxes,1,0,1,82,1,82,0,148,1,0,0,0,0,0,0,0,82,,SSTab,-38,-38,-38,-38
S,SST,Create a SST with prescribed weight given its skew shape,2,0,1,82,0,148,1,1,82,1,82,0,148,3,0,0,0,0,0,0,0,148,,0,0,82,,0,0,82,,SSTab,-38,-38,-38,-38
S,SST,Create a SST given its skew shape with weight = number of boxes,2,0,1,82,0,148,1,1,82,1,82,0,148,2,0,0,0,0,0,0,0,82,,0,0,82,,SSTab,-38,-38,-38,-38
S,Print,Print T,0,1,0,0,1,0,0,0,0,SSTab,,-38,-38,-38,-38,-38
S,+,Compose two skew tableaux by joining them together,0,2,0,0,0,0,0,0,0,SSTab,,0,0,SSTab,,SSTab,-38,-38,-38,-38
S,Weight,Return the weight of the tableaux,0,1,0,0,0,0,0,0,0,SSTab,,148,-38,-38,-38,-38
