# SPECIFICATION: simple_optimization

## Overview
Contract-verified parameter optimization library implementing Nelder-Mead simplex and gradient descent methods. Supports numerical and analytical gradients, variable bounds, and convergence tolerances. Designed for parameter fitting, curve fitting, and machine learning applications with SCOOP-compatible ensemble optimization support.

## Class Specifications

### SIMPLE_OPTIMIZATION (Facade)

```eiffel
note
    description: "Entry point for optimization solvers."
    author: "Larry Rix"

class SIMPLE_OPTIMIZATION

create
    make

feature -- Solver Creation

    create_nelder_mead_solver: NELDER_MEAD_SOLVER
            -- Factory for Nelder-Mead simplex solver.
        do
            create Result.make
        ensure
            result_not_void: Result /= Void
        end

    create_gradient_descent_solver: GRADIENT_DESCENT_SOLVER
            -- Factory for gradient descent solver.
        do
            create Result.make
        ensure
            result_not_void: Result /= Void
        end

end
```

### NELDER_MEAD_SOLVER (Engine)

```eiffel
note
    description: "Nelder-Mead simplex method for unconstrained optimization."
    author: "Larry Rix"

class NELDER_MEAD_SOLVER

create
    make

feature {NONE} -- Initialization

    make
        do
            absolute_tolerance := 1.0e-8
            relative_tolerance := 1.0e-10
            max_iterations := 1000
            create lower_bound.make_filled (REAL_64.min_value, 1, 10)
            create upper_bound.make_filled (REAL_64.max_value, 1, 10)
        ensure
            tolerances_set: absolute_tolerance = 1.0e-8
        end

feature -- Configuration

    set_absolute_tolerance (a_tol: REAL_64): like Current
        require
            positive: a_tol > 0.0
        do
            absolute_tolerance := a_tol
            Result := Current
        ensure
            set: absolute_tolerance = a_tol
            result_current: Result = Current
        end

    set_max_iterations (n: INTEGER): like Current
        require
            positive: n > 0
        do
            max_iterations := n
            Result := Current
        ensure
            set: max_iterations = n
            result_current: Result = Current
        end

    set_lower_bound (a_bound: ARRAY [REAL_64]): like Current
        require
            bound_not_void: a_bound /= Void
        do
            lower_bound := a_bound
            Result := Current
        ensure
            set: lower_bound = a_bound
            result_current: Result = Current
        end

    set_upper_bound (a_bound: ARRAY [REAL_64]): like Current
        require
            bound_not_void: a_bound /= Void
        do
            upper_bound := a_bound
            Result := Current
        ensure
            set: upper_bound = a_bound
            result_current: Result = Current
        end

feature -- Optimization

    minimize (f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64];
              x0: ARRAY [REAL_64]): OPTIMIZATION_RESULT
        require
            f_not_void: f /= Void
            x0_not_void: x0 /= Void
            x0_not_empty: x0.count > 0
        do
            -- Implementation: Nelder-Mead iteration
            -- (Phase 4 stub)
            create Result.make_from_optimization (...)
        ensure
            result_not_void: Result /= Void
            dimension_preserved: Result.x_minimum.count = x0.count
            bounds_respected: across Result.x_minimum as i all
                Result.x_minimum[i.index] >= lower_bound[i.index] and
                Result.x_minimum[i.index] <= upper_bound[i.index]
            end
        end

feature {NONE} -- Implementation

    absolute_tolerance: REAL_64
    relative_tolerance: REAL_64
    max_iterations: INTEGER
    lower_bound: ARRAY [REAL_64]
    upper_bound: ARRAY [REAL_64]

end
```

### GRADIENT_DESCENT_SOLVER (Engine)

```eiffel
note
    description: "Gradient descent with line search."
    author: "Larry Rix"

class GRADIENT_DESCENT_SOLVER

create
    make

feature {NONE} -- Initialization

    make
        do
            absolute_tolerance := 1.0e-8
            gradient_step := 1.0e-5
            initial_step_size := 1.0
            max_iterations := 1000
            create lower_bound.make_filled (REAL_64.min_value, 1, 10)
            create upper_bound.make_filled (REAL_64.max_value, 1, 10)
        ensure
            tolerances_set: absolute_tolerance = 1.0e-8
        end

feature -- Configuration

    set_absolute_tolerance (a_tol: REAL_64): like Current
        require
            positive: a_tol > 0.0
        do
            absolute_tolerance := a_tol
            Result := Current
        ensure
            set: absolute_tolerance = a_tol
            result_current: Result = Current
        end

    set_gradient_function (a_grad: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], ARRAY [REAL_64]]): like Current
        require
            grad_not_void: a_grad /= Void
        do
            gradient_function := a_grad
            use_analytical_gradient := True
            Result := Current
        ensure
            set: gradient_function = a_grad
            result_current: Result = Current
        end

    set_gradient_step (eps: REAL_64): like Current
        require
            positive: eps > 0.0
            small: eps < 0.1
        do
            gradient_step := eps
            Result := Current
        ensure
            set: gradient_step = eps
            result_current: Result = Current
        end

    set_initial_step_size (alpha: REAL_64): like Current
        require
            positive: alpha > 0.0
        do
            initial_step_size := alpha
            Result := Current
        ensure
            set: initial_step_size = alpha
            result_current: Result = Current
        end

    set_max_iterations (n: INTEGER): like Current
        require
            positive: n > 0
        do
            max_iterations := n
            Result := Current
        ensure
            set: max_iterations = n
            result_current: Result = Current
        end

feature -- Optimization

    minimize (f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64];
              x0: ARRAY [REAL_64]): OPTIMIZATION_RESULT
        require
            f_not_void: f /= Void
            x0_not_void: x0 /= Void
            x0_not_empty: x0.count > 0
        do
            -- Implementation: Gradient descent iteration
            -- (Phase 4 stub)
            create Result.make_from_optimization (...)
        ensure
            result_not_void: Result /= Void
            dimension_preserved: Result.x_minimum.count = x0.count
            monotone_decrease: f(Result.x_minimum) <= f(x0)
        end

feature {NONE} -- Implementation

    absolute_tolerance: REAL_64
    gradient_step: REAL_64
    initial_step_size: REAL_64
    max_iterations: INTEGER
    gradient_function: detachable FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], ARRAY [REAL_64]]
    use_analytical_gradient: BOOLEAN
    lower_bound: ARRAY [REAL_64]
    upper_bound: ARRAY [REAL_64]

end
```

### OPTIMIZATION_RESULT (Data - Immutable)

```eiffel
note
    description: "Immutable optimization results."
    author: "Larry Rix"

class OPTIMIZATION_RESULT

create
    make_from_optimization

feature {NONE} -- Initialization

    make_from_optimization (a_x_min, a_x_init: ARRAY [REAL_64];
                            a_f_min, a_f_init: REAL_64;
                            a_iters, a_evals: INTEGER;
                            a_converged: BOOLEAN;
                            a_reason: STRING;
                            a_grad_norm: REAL_64)
        do
            x_minimum := a_x_min
            x_initial := a_x_init
            f_minimum := a_f_min
            f_initial := a_f_init
            iterations := a_iters
            function_evaluations := a_evals
            converged := a_converged
            convergence_reason := a_reason
            gradient_norm := a_grad_norm
        ensure
            x_minimum_set: x_minimum.count = a_x_min.count
        end

feature -- Access

    x_minimum: ARRAY [REAL_64]
            -- Optimal parameters found.

    x_initial: ARRAY [REAL_64]
            -- Starting parameters.

    f_minimum: REAL_64
            -- Objective value at minimum.

    f_initial: REAL_64
            -- Objective value at starting point.

    iterations: INTEGER
            -- Number of iterations performed.

    function_evaluations: INTEGER
            -- Total objective function evaluations.

    gradient_norm: REAL_64
            -- Norm of gradient at final point.

    simplex_diameter: REAL_64
            -- Nelder-Mead simplex size (convergence measure).

    converged: BOOLEAN
            -- TRUE if convergence criteria met.

    convergence_reason: STRING
            -- Why optimization stopped.

    dimension: INTEGER
            -- Number of variables.
        do
            Result := x_minimum.count
        ensure
            consistent: Result = x_initial.count
        end

invariant
    x_minimum_not_void: x_minimum /= Void
    x_minimum_not_empty: x_minimum.count > 0
    iterations_non_negative: iterations >= 0
    function_evals_positive: function_evaluations > 0
    f_minimum_reasonable: not f_minimum.is_nan

end
```

## Dependencies

| Library | Purpose | Version |
|---------|---------|---------|
| simple_math | sqrt for gradient norm, exp for line search | 1.0.0+ |
| ISE base | ARRAY, fundamental types | 25.02+ |
| ISE testing | EQA_TEST_SET | 25.02+ |

## File Structure

```
src/
├── simple_optimization.e           (Facade)
├── nelder_mead_solver.e            (Simplex method)
├── gradient_descent_solver.e       (Steepest descent)
├── simplex.e                       (Vertex management)
├── gradient_vector.e               (Gradient data)
├── line_search.e                   (Armijo backtracking)
├── convergence_checker.e           (Convergence detection)
├── optimization_result.e           (Results)
└── optimization_history.e          (Optional iteration tracking)

test/
├── test_nelder_mead.e             (Simplex convergence)
├── test_gradient_descent.e        (Gradient descent convergence)
├── test_rosenbrock.e              (Rosenbrock function)
├── test_sphere.e                  (Sphere function)
├── test_bounds.e                  (Bound enforcement)
└── test_app.e                     (Test runner)
```

## Phase 1 Implementation Strategy

1. **Nelder-Mead:** n+1 simplex vertices, reflection/expansion/contraction
2. **Gradient Descent:** Numerical (default) or analytical gradient, line search
3. **Line Search:** Armijo backtracking with step halving
4. **Bounds:** Box constraints via projection
5. **Convergence:** Multiple criteria (tol, gradient norm, iterations)

## Performance Targets

- Dimension: up to 50+ variables
- Function evaluations: minimize for efficiency
- Gradient evals: N for numerical gradient (N = dimension)
- Line search: typically 3-10 backtracks per iteration

## Correctness Properties

- **Nelder-Mead:** Converges to local minimum (simplex contracts)
- **Gradient descent:** Monotone decrease in objective value
- **Line search:** Sufficient decrease condition (Armijo)
- **Neither method** guarantees global minimum (local search only)

## Future Extensions (Phase 2)

- Multi-start global search (parallel via SCOOP)
- Simulated annealing
- Quasi-Newton (BFGS)
- Constrained optimization (SQP, penalty methods)
- Scale-invariant convergence criteria
