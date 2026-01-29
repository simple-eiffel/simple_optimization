# Implementation Tasks: simple_optimization

## Task 1: GRADIENT_VECTOR - Gradient Data Class
**Files:** src/gradient_vector.e
**Features:** x, y, z (components), magnitude, dot_product, scale

### Acceptance Criteria
- [ ] Creation: make (from ARRAY [REAL_64])
- [ ] Access: Components via x, y, z or array indexing
- [ ] magnitude: REAL_64 (||∇f||)
- [ ] dot_product (other: GRADIENT_VECTOR): REAL_64
- [ ] scale (scalar: REAL_64): GRADIENT_VECTOR
- [ ] Immutable: No modification after creation
- [ ] Preconditions: Array not void, not empty
- [ ] Postconditions: Magnitude >= 0, dimension preserved
- [ ] Test: Gradient norms, dot products

### Implementation Notes
- **Gradient representation:** ARRAY [REAL_64] components
- **Magnitude:** sqrt(sum of components²) for convergence check
- **Immutable:** Like VECTOR_3D in simple_physics
- **Dimension:** Flexible (not fixed to 3D)

### Dependencies
None (foundation class)

---

## Task 2: SIMPLEX - Nelder-Mead Vertex Management
**Files:** src/simplex.e
**Features:** vertices, values, worst_index, best_index, centroid, contract, expand, reflect, shrink

### Acceptance Criteria
- [ ] Creation: make (n+1 initial vertices in ℝⁿ)
- [ ] vertices: ARRAY [ARRAY [REAL_64]] (n+1 points)
- [ ] values: ARRAY [REAL_64] (f evaluated at each vertex)
- [ ] worst_index: INTEGER (index of highest f value)
- [ ] best_index: INTEGER (index of lowest f value)
- [ ] centroid (excluding worst): ARRAY [REAL_64]
- [ ] Nelder-Mead operations:
  - reflect (α=1.0): Reflect worst across centroid
  - expand (γ=2.0): Expand successful reflection
  - contract (ρ=0.5): Contract toward best
  - shrink (σ=0.5): Shrink all toward best
- [ ] diameter: REAL_64 (simplex size for convergence)
- [ ] Preconditions: Vertices not void, at least n+1 points
- [ ] Postconditions: Operations modify vertices, values updated
- [ ] Test: Simplex operations preserve dimension

### Implementation Notes
- **n+1 vertices:** For n-dimensional space
- **Reflection:** x_reflect = x_centroid + α*(x_centroid - x_worst)
- **Expansion:** x_expand = x_centroid + γ*(x_reflect - x_centroid)
- **Contraction:** x_contract = x_centroid + ρ*(x_worst - x_centroid)
- **Shrinkage:** x_shrink[i] = x_best + σ*(x[i] - x_best)
- **Diameter:** max distance between vertices
- **Function evals:** Each operation requires 1 function evaluation

### Dependencies
None (pure data structure + operations)

---

## Task 3: OPTIMIZATION_RESULT - Results Data Class (Immutable)
**Files:** src/optimization_result.e
**Features:** x_minimum, f_minimum, x_initial, f_initial, iterations, function_evaluations, gradient_norm, simplex_diameter, converged, convergence_reason, dimension, history

### Acceptance Criteria
- [ ] Creation: make_from_optimization with all components
- [ ] x_minimum: ARRAY [REAL_64] (optimal parameters)
- [ ] f_minimum: REAL_64 (objective value at minimum)
- [ ] x_initial: ARRAY [REAL_64] (starting point)
- [ ] f_initial: REAL_64 (value at start)
- [ ] iterations: INTEGER (number of iterations)
- [ ] function_evaluations: INTEGER (total f(x) calls)
- [ ] gradient_norm: REAL_64 (||∇f|| at final point, for gradient descent)
- [ ] simplex_diameter: REAL_64 (for Nelder-Mead)
- [ ] converged: BOOLEAN (success flag)
- [ ] convergence_reason: STRING ("tolerance", "max_iterations", "bounds")
- [ ] dimension: INTEGER (number of variables)
- [ ] history: detachable OPTIMIZATION_HISTORY (optional trajectory)
- [ ] Immutable: No modification after creation
- [ ] Invariants: Result not void, dimension preserved
- [ ] SCOOP-safe: Immutable for shared access

### Implementation Notes
- **Immutable data class:** Safe for concurrent SCOOP sharing
- **Convergence reasons:** "tolerance" (met criteria), "max_iterations" (limit), "bounds" (constraint)
- **Gradient norm:** Only for gradient descent (zero for Nelder-Mead)
- **Simplex diameter:** Only for Nelder-Mead (zero for gradient descent)
- **History:** Optional detailed trajectory (disable for memory efficiency)
- **Dimension:** x_minimum.count = x_initial.count

### Dependencies
- Depends on: OPTIMIZATION_HISTORY (optional)

---

## Task 4: OPTIMIZATION_HISTORY - Optional Iteration Tracking
**Files:** src/optimization_history.e
**Features:** iterations, values, final_gradient_norm

### Acceptance Criteria
- [ ] Creation: make with iteration count
- [ ] iterations: LIST [ARRAY [REAL_64]] (x values per iteration)
- [ ] values: LIST [REAL_64] (f(x) per iteration)
- [ ] Monotone decrease: values[i] >= values[i+1] for all i
- [ ] Record: add_iteration (x, f_value)
- [ ] Query: iteration_count, best_value, best_x
- [ ] Immutable final: Can't add after solve completes
- [ ] Test: History tracks optimization trajectory

### Implementation Notes
- **Optional feature:** Can be disabled for memory efficiency
- **Monotone check:** Postcondition verifies non-increase in f
- **Memory:** Stores all iterations (could be large for 1000+ iterations)
- **Trajectory:** Useful for visualization and debugging

### Dependencies
None (data structure)

---

## Task 5: SIMPLE_OPTIMIZATION - Facade Entry Point
**Files:** src/simple_optimization.e
**Features:** make, create_nelder_mead_solver, create_gradient_descent_solver

### Acceptance Criteria
- [ ] Creation: make (default initialization)
- [ ] create_nelder_mead_solver: NELDER_MEAD_SOLVER factory
- [ ] create_gradient_descent_solver: GRADIENT_DESCENT_SOLVER factory
- [ ] Fluent chaining: create.create_nelder_mead_solver.set_tolerance.minimize works
- [ ] Preconditions: Factories always succeed
- [ ] Postconditions: Solvers not void, ready for configuration
- [ ] Test: Facade creation, solver factory methods

### Implementation Notes
- **Facade pattern:** Dispatches to appropriate solver
- **Factory methods:** Create new solver instances
- **Fluent pattern:** Each solver returns like Current for chaining

### Dependencies
- Depends on: NELDER_MEAD_SOLVER (creates)
- Depends on: GRADIENT_DESCENT_SOLVER (creates)

---

## Task 6: LINE_SEARCH - Armijo Backtracking
**Files:** src/line_search.e
**Features:** compute_step_size

### Acceptance Criteria
- [ ] compute_step_size (x, direction, f, gradient_dot_direction): REAL_64
- [ ] Armijo condition: f(x + α*d) <= f(x) + c*α*(∇f·d)
  - c = 1e-4 (sufficient decrease parameter)
  - Initial α = 1.0
  - Backtracking: Halve α until Armijo satisfied or max_backtracks reached
- [ ] Line search parameters:
  - alpha_initial: 1.0
  - c_armijo: 1e-4
  - max_backtracks: 10
- [ ] Preconditions: direction is descent (∇f·d < 0)
- [ ] Postconditions: 0 < α <= alpha_initial, Armijo satisfied
- [ ] Test: Step size computed correctly, Armijo condition verified

### Implementation Notes
- **Armijo condition:** Guarantees sufficient decrease toward minimum
- **Backtracking loop:** While Armijo not satisfied and backtracks < max:
  - α = α / 2
  - Check Armijo
- **Descent check:** Precondition grad_f_dot_d < 0 (descent direction)
- **Parameters:** Tunable for aggression/stability trade-off

### Dependencies
None (pure function)

---

## Task 7: CONVERGENCE_CHECKER - Convergence Detection
**Files:** src/convergence_checker.e
**Features:** check_nelder_mead_convergence, check_gradient_convergence, should_continue

### Acceptance Criteria
- [ ] check_nelder_mead_convergence (simplex_diameter, f_max, f_min, tolerance): BOOLEAN
- [ ] Convergence when:
  - simplex_diameter < absolute_tolerance AND
  - |f_max - f_min| < relative_tolerance * |f_min|
- [ ] check_gradient_convergence (gradient_norm, tolerance): BOOLEAN
- [ ] Convergence when: ||∇f|| < tolerance
- [ ] should_continue (iterations, max_iterations, converged): BOOLEAN
- [ ] Continue if: iterations < max_iterations AND NOT converged
- [ ] Preconditions: Tolerances > 0, iterations >= 0
- [ ] Postconditions: Result is deterministic function of inputs
- [ ] Test: Convergence detection on test problems

### Implementation Notes
- **Nelder-Mead:** Both simplex size AND function value range must be small
- **Gradient descent:** Gradient norm is primary criterion
- **Iteration limit:** Hard stop at max_iterations
- **Multiple criteria:** Multiple convergence reasons possible

### Dependencies
None (pure logic)

---

## Task 8: NELDER_MEAD_SOLVER - Simplex Method
**Files:** src/nelder_mead_solver.e
**Features:** make, set_absolute_tolerance, set_relative_tolerance, set_max_iterations, set_lower_bound, set_upper_bound, set_track_history, minimize

### Acceptance Criteria
- [ ] Creation: make (default parameters)
- [ ] Configuration (all return Current for chaining):
  - set_absolute_tolerance (a_tol: REAL_64)
  - set_relative_tolerance (a_tol: REAL_64)
  - set_max_iterations (n: INTEGER)
  - set_lower_bound (a_bound: ARRAY [REAL_64])
  - set_upper_bound (a_bound: ARRAY [REAL_64])
  - set_track_history (flag: BOOLEAN)
- [ ] minimize (f, x0): OPTIMIZATION_RESULT
  - Create initial simplex (n+1 vertices around x0)
  - Nelder-Mead iterations:
    1. Evaluate f at all vertices
    2. Identify worst, second-worst, best
    3. Reflect worst across centroid
    4. If reflected is better than second-worst: evaluate expansion
    5. If reflected is worse than worst: evaluate contraction
    6. If no improvement: shrink simplex toward best
  - Repeat until convergence (simplex diameter < tol)
  - Return OPTIMIZATION_RESULT with trajectory
- [ ] Preconditions: f not void, x0 not void, x0 in bounds
- [ ] Postconditions: Result in bounds, converged or max_iterations reached
- [ ] Test: Rosenbrock function, sphere function, Rastrigin (multimodal)

### Implementation Notes
- **Initial simplex:** x0 + δ*e_i for i = 1..n, where δ ~ 0.1
- **Reflection parameter:** α = 1.0 (standard)
- **Expansion parameter:** γ = 2.0
- **Contraction parameter:** ρ = 0.5
- **Shrinkage parameter:** σ = 0.5
- **Vertex ordering:** Keep sorted by f value for efficiency
- **Bounds projection:** If new vertex violates bounds, project to boundary

### Dependencies
- Depends on: SIMPLEX (vertex management)
- Depends on: CONVERGENCE_CHECKER (stopping criterion)
- Depends on: OPTIMIZATION_RESULT (result container)
- Depends on: OPTIMIZATION_HISTORY (optional trajectory)

---

## Task 9: GRADIENT_DESCENT_SOLVER - Steepest Descent with Line Search
**Files:** src/gradient_descent_solver.e
**Features:** make, set_absolute_tolerance, set_gradient_function, set_gradient_step, set_initial_step_size, set_max_iterations, set_lower_bound, set_upper_bound, minimize

### Acceptance Criteria
- [ ] Creation: make (default parameters)
- [ ] Configuration (all return Current for chaining):
  - set_absolute_tolerance (a_tol: REAL_64)
  - set_gradient_function (a_grad: FUNCTION) - user-provided ∇f (optional)
  - set_gradient_step (eps: REAL_64) - finite difference step size
  - set_initial_step_size (α: REAL_64)
  - set_max_iterations (n: INTEGER)
  - set_lower_bound, set_upper_bound
- [ ] minimize (f, x0): OPTIMIZATION_RESULT
  - Main loop while convergence not met:
    1. Compute gradient (analytical or numerical)
    2. If gradient norm < tol: converge
    3. Direction: d = -∇f (steepest descent)
    4. Line search (Armijo): find α such that f(x + α*d) decreases
    5. Update: x = x + α*d
    6. Project to bounds if needed
  - Repeat until ||∇f|| < tolerance or max_iterations
  - Return OPTIMIZATION_RESULT
- [ ] Numerical gradient: finite differences with central difference
  - ∂f/∂xi ≈ [f(x + eps*e_i) - f(x - eps*e_i)] / (2*eps)
- [ ] Analytical gradient: optional, user-provided callback
- [ ] Preconditions: f not void, x0 not void, x0 in bounds
- [ ] Postconditions: Result in bounds, monotone decrease in f
- [ ] Test: Quadratic, Rosenbrock, ill-conditioned problems

### Implementation Notes
- **Gradient computation:**
  - Numerical (default): 2N function evals per gradient (central differences)
  - Analytical (optional): User provides ∇f directly
- **Line search:** Armijo backtracking (Task 6)
- **Bounds handling:** Project x back to bounds after update if violated
- **Descent check:** Ensure ∇f·d < 0 before line search
- **Convergence:** ||∇f|| < tolerance (primary), iteration limit (secondary)

### Dependencies
- Depends on: GRADIENT_VECTOR (gradient representation)
- Depends on: LINE_SEARCH (Armijo backtracking)
- Depends on: CONVERGENCE_CHECKER (stopping criterion)
- Depends on: OPTIMIZATION_RESULT (result container)
- Depends on: OPTIMIZATION_HISTORY (optional trajectory)

---

## Task 10: ECF Configuration and Test Framework
**Files:** simple_optimization.ecf, test/test_app.e, test/test_rosenbrock.e, test/test_sphere.e, test/test_bounds.e

### Acceptance Criteria
- [ ] ECF file: void_safety="all", concurrency=scoop, simple_math dependency
- [ ] Test targets: main (library) and test (test suite)
- [ ] Test runner: test_app.e orchestrates all tests
- [ ] Skeletal tests:
  - test_rosenbrock.e: Rosenbrock function f(x,y) = (1-x)² + 100*(y-x²)²
  - test_sphere.e: Sphere function f(x) = sum(x_i²)
  - test_bounds.e: Verify bound constraints enforced
- [ ] Compilation: Zero warnings
- [ ] Test execution: All skeletal tests pass (100% pass rate)
- [ ] Solver comparison: Nelder-Mead vs gradient descent on test functions

### Implementation Notes
- **Rosenbrock function:** Global minimum at (1, 1) with f = 0; highly curved
- **Sphere function:** Global minimum at origin (0, ..., 0) with f = 0; simple
- **Bounds test:** Minimize f(x) = -sum(x_i) subject to 0 <= x_i <= 1
- **ECF targets:** simple_optimization (library), simple_optimization_tests (test)
- **Dependencies:** base, testing from ISE; simple_math for special functions

### Dependencies
- Depends on: All other classes (integration point)

---

## Task Dependency Graph

```
GRADIENT_VECTOR (Task 1)
        ↓
SIMPLEX (Task 2)
        ↓
OPTIMIZATION_RESULT (Task 3) ← OPTIMIZATION_HISTORY (Task 4)
        ↓
SIMPLE_OPTIMIZATION (Task 5)
        ↓ ↓
NELDER_MEAD_SOLVER  GRADIENT_DESCENT_SOLVER (Tasks 8-9)
(Task 8)            ↑ ↑ ↑
    ↓               │ │ │
    │           LINE_SEARCH (Task 6)
    │           │
    └─────────┬─┘
              │
    CONVERGENCE_CHECKER (Task 7)
              ↓
        ECF & Tests
        (Task 10)
```

## Task Execution Order (Recommended)

1. **Foundation (parallel):**
   - Task 1: GRADIENT_VECTOR
   - Task 2: SIMPLEX
   - Task 3: OPTIMIZATION_RESULT
   - Task 4: OPTIMIZATION_HISTORY

2. **Utility classes (parallel after foundation):**
   - Task 6: LINE_SEARCH
   - Task 7: CONVERGENCE_CHECKER

3. **Entry point (depends on Tasks 2-3):**
   - Task 5: SIMPLE_OPTIMIZATION

4. **Solvers (parallel, depends on Tasks 1-7):**
   - Task 8: NELDER_MEAD_SOLVER
   - Task 9: GRADIENT_DESCENT_SOLVER

5. **Integration & testing (final):**
   - Task 10: ECF & Tests

## Total Task Count: 10
- Data classes: 3
- Utility classes: 2
- Solver classes: 2
- Helper classes: 2
- Integration: 1

**Estimated complexity:** MEDIUM (standard optimization algorithms)
**Critical algorithms:** Nelder-Mead simplex, gradient descent, line search
**Success factors:** Correct Armijo implementation, proper bounds handling, convergence testing

---

## Phase 3 Complete for All Three Projects

- **simple_physics:** 12 tasks ✓
- **simple_ode:** 10 tasks ✓
- **simple_optimization:** 10 tasks ✓

**Total: 32 implementable tasks across 28 classes**

Ready for Phase 4 (Implementation) approval.
