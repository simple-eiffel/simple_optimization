# RECOMMENDATION: simple_optimization

## Executive Summary
simple_optimization should be built as a contract-verified numerical optimization library focusing on gradient descent and Nelder-Mead simplex methods for unconstrained + bounded optimization. It enables parameter fitting and scientific computing in Eiffel without Python/SciPy, with SCOOP support for parallel ensemble optimization.

## Recommendation
**Action:** BUILD
**Confidence:** HIGH

## Rationale
1. **Ecosystem gap:** No optimization library in Eiffel; ML/parameter fitting must use external tools
2. **Well-solved problem:** Gradient descent and Nelder-Mead are standard, implementable
3. **Reasonable MVP scope:** Local search sufficient for many applications
4. **Contract advantage:** Can formally verify convergence and tolerance
5. **SCOOP opportunity:** Enable parallel multi-start optimization trials

## Proposed Approach

### Phase 1 (MVP) - 2-3 months
- **Local search methods:**
  - Nelder-Mead simplex (gradient-free)
  - Gradient descent with line search (Armijo backtracking)
  - Steepest descent implementation
- **Features:**
  - Unconstrained optimization
  - Bounds (box constraints)
  - Numerical gradient via finite differences
  - Optional analytical gradient
  - Convergence tolerance control
  - Result with minimum found, iterations, status
- **Quality:**
  - 35+ tests (100% pass rate)
  - Full contract coverage
  - Standard test functions (Rosenbrock, Rastrigin, etc.)

### Phase 2 (Full) - Future
- Conjugate gradient method
- BFGS quasi-Newton
- Nonlinear constraint handling (SQP, penalty methods)
- Global search (multi-start, simulated annealing)
- Hessian-based methods
- Adaptive learning rates

## Key Features
1. **Contract-Verified Convergence** - Tolerance specified; accuracy guaranteed
2. **Pure Eiffel Implementation** - No FFI to GSL or NLopt
3. **Parameter Fitting Ready** - Objective function interface for least-squares
4. **Ensemble Optimization** - Multi-start with concurrent trials via SCOOP
5. **Flexible Gradients** - User-provided or automatic numerical derivatives

## Success Criteria
- Rosenbrock function minimization converges to known minimum
- Simple test functions converge within specified tolerance
- 35+ tests passing (100% pass rate)
- Zero compilation warnings
- Clear documentation with parameter fitting examples

## Dependencies
| Library | Purpose | simple_* Preferred |
|---------|---------|-------------------|
| simple_math | sqrt for norm computation | YES |
| simple_linalg | Future: Hessian matrix operations | YES (Phase 2) |

## Next Steps
1. Run `/eiffel.spec` to create formal specification
2. Run `/eiffel.intent` to refine intent
3. Execute Eiffel Spec Kit workflow (Phases 1-7)
4. Target Q2 2026 completion

## Open Questions
- Should MVP include 1D minimization (golden section) or only multidimensional? → Include 1D, useful for line search
- What is maximum problem dimensionality for Phase 1? → Recommend < 100 variables
- Should bounds be enforced via penalties or projections? → Projections (simpler, deterministic)
