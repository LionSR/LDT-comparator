import MIPStarRE.LDT.Test.MainTheorem.MainFormal

/-!
# Solution

The MIPStarRE library itself proves the challenge theorem
`MIPStarRE.LDT.Test.mainFormal`.  `Challenge.lean` re-declares the statement's
definitional closure verbatim under the same fully-qualified names, so
importing the library is the entire solution; comparator checks that the two
environments declare identical statements.
-/
