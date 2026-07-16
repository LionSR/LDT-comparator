# LDT-comparator

Independent, auditable verification that the
[MIPStarRE](https://github.com/LionSR/MIPStarRE) library proves the main
theorem (`thm:main-formal`) of *Quantum soundness of the classical low
individual degree test* ([arXiv:2009.12982](https://arxiv.org/abs/2009.12982),
Ji–Natarajan–Vidick–Wright–Yuen) — the central technical ingredient of
MIP\* = RE ([arXiv:2001.04383](https://arxiv.org/abs/2001.04383)).

Following the pattern of
[lamplighter-comparator](https://github.com/vidick/lamplighter-comparator) and
[erdos-unit-distance-comparator](https://github.com/kim-em/erdos-unit-distance-comparator):

- **`Challenge.lean`** imports **only Mathlib** and states the theorem
  `MIPStarRE.LDT.Test.mainFormal` self-containedly (every definition in the
  statement's closure is re-declared in this one file, with provenance
  comments), ending in `sorry`. *This file is the entire audit surface*: a
  reader who agrees it states the intended theorem does not need to read the
  library.
- **`Solution.lean`** imports the library (pinned by commit in
  `lakefile.toml`), which proves the theorem under the same fully-qualified
  names.
- **`./verify.sh`** (Linux, or GitHub Actions on every push) runs the official
  [leanprover/comparator](https://github.com/leanprover/comparator): it
  rebuilds both modules sandboxed under landrun, exports them with
  lean4export, checks that every declaration reachable from the statement is
  identical in both environments, checks that the proof uses no axioms beyond
  `propext`, `Quot.sound`, `Classical.choice`, and replays it through the Lean
  kernel and the independent [nanoda](https://github.com/ammkrn/nanoda_lib)
  kernel.

A successful run certifies: **if you believe `Challenge.lean` says the
intended theorem, the library proves it from the standard axioms.**

On macOS (no Landlock) use `./verify.sh --fake-landrun` for a functional,
non-sandboxed check via comparator's official development stub.

`Challenge.lean` is generated from the library by the tooling in the main
repository (`scripts/comparator/`); regenerate and copy it here when bumping
the library pin.
