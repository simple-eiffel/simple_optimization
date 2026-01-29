# CHALLENGED ASSUMPTIONS: simple_optimization

## Assumptions Challenged

### A-001: Nelder-Mead Sufficient Without Global Search
**Challenge:** Most users want global minima, not local. Should Phase 1 include multi-start?
**Evidence for:** Multi-start is simple add-on; SCOOP enables easy parallelization
**Evidence against:** MVP should focus on core algorithms; global search inherently Phase 2
**Verdict:** VALID - Local methods Phase 1; multi-start SCOOP pattern in Phase 2
**Action:** Document clearly that Phase 1 finds local minima only

### A-002: Numerical Gradients Sufficient
**Challenge:** Should all users provide analytical gradients?
**Evidence for:** Analytical faster when available; numerical reliable for testing
**Evidence against:** Analytical burdensome for users; numerical gives flexibility
**Verdict:** VALID - Numerical default; analytical optional (user provides if needed)
**Action:** Documentation shows both patterns; numerical preferred

### A-003: Bounds Only (No General Constraints)
**Challenge:** Could MVP support linear equality constraints?
**Evidence for:** Linear constraints easy to implement
**Evidence against:** Complicates MVP; penalty method adds complexity
**Verdict:** VALID - Bounds only Phase 1; general constraints Phase 2 with SQP
**Action:** Clear documentation of constraint limitation; workarounds provided

### A-004: Armijo Backtracking Is Best Line Search
**Challenge:** Could we use Wolfe or other conditions?
**Evidence for:** Armijo simple, proven, reliable; sufficient for gradient descent
**Evidence against:** Wolfe guarantees might be better theoretically
**Verdict:** VALID - Armijo sufficient for MVP; upgrade in Phase 2
**Action:** Implement Armijo carefully; Phase 2 extends to Wolfe conditions

### A-005: Separate Solver Classes (Not Unified API)
**Challenge:** Should we follow scipy.optimize.minimize pattern (single minimize function)?
**Evidence for:** Unified API familiar to SciPy users
**Evidence against:** Separate classes give per-solver tuning parameters; more Eiffel-like
**Verdict:** VALID - Separate NELDER_MEAD_SOLVER and GRADIENT_DESCENT_SOLVER
**Action:** Each solver owns configuration; future facade if needed

### A-006: simple_math Provides All Functions
**Challenge:** Are sqrt, exp, log available?
**Evidence for:** Standard mathematical library
**Evidence against:** Possible gap if simple_math incomplete
**Verdict:** NEEDS_VALIDATION - Integration gate required
**Action:** Verify sqrt, exp, log available before Phase 1 implementation

### A-007: No Scaling/Preconditioning Needed
**Challenge:** Should Phase 1 include automatic variable scaling?
**Evidence for:** Gradient descent on ill-conditioned problems diverges
**Evidence against:** Scaling adds complexity; users can scale inputs
**Verdict:** MODIFY - Document scaling requirement; users scale manually Phase 1
**Action:** Phase 2 adds adaptive preconditioning

## Requirements Questioned

### FR-002: Nelder-Mead Convergence Criterion
**Requirement:** Nelder-Mead simplex minimization works
**Challenge:** What is "works"? Simplex size < tol? Function value change < tol?
**Verdict:** CLARIFY - Multiple criteria: ||simplex diameter|| < tol AND |f_max - f_min| < tol
**Action:** Both conditions must hold for convergence

### FR-003: Gradient Descent Finds Local Minimum
**Requirement:** Steepest descent converges to local minimum
**Challenge:** How fast? How accurate?
**Verdict:** CLARIFY - Converges to stationary point (||∇f|| < tol)
**Action:** May not be strict local minimum; Phase 2 verifies Hessian

### FR-010: Line Search Convergence
**Requirement:** Armijo or backtracking line search
**Challenge:** What are Armijo parameters (c, max_backtracks)?
**Verdict:** CLARIFY - c = 1e-4, max_backtracks = 10, initial α = 1.0
**Action:** Tunable parameters in solver configuration

## Missing Requirements Identified

| ID | Missing Requirement | How Discovered |
|----|---------------------|-----------------|
| FR-015 | Gradient norm as convergence criterion | Alternative to function value |
| FR-016 | Scale-invariant convergence tolerance | Prevent sensitivity to units |
| FR-017 | Iteration history / optimization trajectory | Useful for debugging |
| FR-018 | Hessian verification (local minimum check) | Distinguish minimum from saddle |
| FR-019 | Function evaluation budget (vs iteration count) | May hit evals before iterations |

**Decisions:**
- FR-015: ADD to Phase 1 (gradient norm convergence for gradient descent)
- FR-016: DEFERRED to Phase 2 (scale-invariant metrics)
- FR-017: ADD to Phase 1 (optional history tracking)
- FR-018: DEFERRED to Phase 2 (Hessian-based verification)
- FR-019: ADD to Phase 1 (max_function_evals limit)

## Design Constraints Validated

| Constraint | Valid? | Notes |
|-----------|--------|-------|
| Separate solver classes | YES | Allows per-solver tuning |
| Bounds support | YES | Easy to enforce in iterations |
| Numerical gradients | YES | Finite differences reliable |
| Analytical gradients | YES | Optional, improves speed |
| simple_math dependency | NEEDS_GATE | sqrt, exp, log required |
| SCOOP compatibility | YES | Immutable results + independent solvers |
| void_safety="all" | YES | No null issues with care |

## Revised Scope (Post-Challenge)

### Phase 1 Final Scope
✓ Nelder-Mead simplex method
✓ Gradient descent with Armijo line search
✓ Numerical gradients (finite differences)
✓ Optional analytical gradients
✓ Variable bounds (box constraints)
✓ Convergence tolerance (function value + gradient norm)
✓ Maximum iteration and function evaluation limits
✓ Iteration history (optional tracking)
✓ Statistics (iterations, function evals)
✗ Global search / multi-start (Phase 2)
✗ Simulated annealing (Phase 2)
✗ Quasi-Newton / BFGS (Phase 2)
✗ General constraints (Phase 2)
✗ Scale-invariant metrics (Phase 2)

### Testing Strategy
- Unit: Gradient computation (numerical vs analytical)
- Integration: Convergence on convex functions
- Local minimum: Quadratic, Rosenbrock, sphere functions
- Bounds: Verify solutions respect x_min, x_max
- Ill-conditioning: Monitor convergence on poorly-scaled problems
- Edge cases: Dimension = 1, bounds collapse, max iterations reached

### Documentation Emphasis
- Clear statement: Phase 1 finds local minima only
- Gradient-based vs simplex trade-offs
- Variable scaling requirement
- Analytical gradient speedup potential
- Phase 2 roadmap (global search, constraints)
