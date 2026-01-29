# INTERFACE DESIGN: simple_optimization

## Public API Summary

### Entry Point: SIMPLE_OPTIMIZATION

| Feature | Purpose | Use |
|---------|---------|-----|
| create_nelder_mead_solver | Factory for Nelder-Mead | `create {SIMPLE_OPTIMIZATION}.make.create_nelder_mead_solver` |
| create_gradient_descent_solver | Factory for gradient descent | `.create_gradient_descent_solver` |

### NELDER_MEAD_SOLVER Configuration

| Feature | Returns | Purpose |
|---------|---------|---------|
| set_absolute_tolerance (a_tol: REAL_64) | like Current | Configure simplex convergence |
| set_relative_tolerance (a_tol: REAL_64) | like Current | Configure relative tolerance |
| set_max_iterations (n: INTEGER) | like Current | Prevent infinite loops |
| set_lower_bound (a_bound: ARRAY [REAL_64]) | like Current | Constrain variables lower |
| set_upper_bound (a_bound: ARRAY [REAL_64]) | like Current | Constrain variables upper |
| set_track_history (flag: BOOLEAN) | like Current | Enable iteration tracking |

### NELDER_MEAD_SOLVER Execution

| Feature | Returns | Purpose |
|---------|---------|---------|
| minimize (f: FUNCTION; x0: ARRAY [REAL_64]) | OPTIMIZATION_RESULT | Find minimum from initial point |

### GRADIENT_DESCENT_SOLVER Configuration

| Feature | Returns | Purpose |
|---------|---------|---------|
| set_absolute_tolerance (a_tol: REAL_64) | like Current | Gradient norm convergence |
| set_gradient_function (a_grad: FUNCTION) | like Current | User-provided ∇f (optional) |
| set_gradient_step (eps: REAL_64) | like Current | Finite difference step size |
| set_initial_step_size (α: REAL_64) | like Current | Line search initial step |
| set_lower_bound (a_bound: ARRAY [REAL_64]) | like Current | Variable bounds |
| set_upper_bound (a_bound: ARRAY [REAL_64]) | like Current | Variable bounds |
| set_max_iterations (n: INTEGER) | like Current | Iteration limit |

### GRADIENT_DESCENT_SOLVER Execution

| Feature | Returns | Purpose |
|---------|---------|---------|
| minimize (f: FUNCTION; x0: ARRAY [REAL_64]) | OPTIMIZATION_RESULT | Find minimum from initial point |

### Query Results (OPTIMIZATION_RESULT)

| Feature | Returns | Purpose |
|---------|---------|---------|
| x_minimum | ARRAY [REAL_64] | Optimal parameter values |
| f_minimum | REAL_64 | Objective value at minimum |
| iterations | INTEGER | Iterations taken |
| function_evaluations | INTEGER | Total f(x) calls |
| gradient_norm | REAL_64 | ||∇f|| at final point |
| simplex_diameter | REAL_64 | Nelder-Mead simplex size |
| converged | BOOLEAN | Convergence success |
| convergence_reason | STRING | Why it stopped |
| history | OPTIMIZATION_HISTORY | Iteration trajectory (if tracked) |

## Builder Pattern Examples

### Example 1: Nelder-Mead with Bounds

```eiffel
local
    solver: NELDER_MEAD_SOLVER
    result: OPTIMIZATION_RESULT
    f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64]
    x0: ARRAY [REAL_64]
    bounds_lo, bounds_hi: ARRAY [REAL_64]
do
    solver := create {SIMPLE_OPTIMIZATION}.make.create_nelder_mead_solver

    create bounds_lo.make_filled (-10.0, 1, 2)
    create bounds_hi.make_filled (10.0, 1, 2)

    result := solver.set_absolute_tolerance (1.0e-6)
                    .set_relative_tolerance (1.0e-8)
                    .set_lower_bound (bounds_lo)
                    .set_upper_bound (bounds_hi)
                    .set_max_iterations (1000)
                    .minimize (f, x0)

    print ("Minimum found at: " + result.x_minimum[1].out + ", " + result.x_minimum[2].out)
    print ("Function value: " + result.f_minimum.out)
    print ("Iterations: " + result.iterations.out)
end
```

### Example 2: Gradient Descent with Analytical Gradient

```eiffel
local
    solver: GRADIENT_DESCENT_SOLVER
    result: OPTIMIZATION_RESULT
    f, grad_f: FUNCTION [...]
    x0: ARRAY [REAL_64]
do
    solver := create {SIMPLE_OPTIMIZATION}.make.create_gradient_descent_solver

    result := solver.set_absolute_tolerance (1.0e-8)
                    .set_gradient_function (grad_f)
                    .set_initial_step_size (0.01)
                    .set_max_iterations (500)
                    .minimize (f, x0)

    if result.converged then
        print ("Converged in " + result.iterations.out + " iterations")
        print ("Gradient norm: " + result.gradient_norm.out)
    else
        print ("Did not converge: " + result.convergence_reason)
    end
end
```

### Example 3: Numerical Gradient (Default)

```eiffel
local
    solver: GRADIENT_DESCENT_SOLVER
    result: OPTIMIZATION_RESULT
    f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64]
    x0: ARRAY [REAL_64]
do
    solver := create {SIMPLE_OPTIMIZATION}.make.create_gradient_descent_solver

    -- No set_gradient_function: use numerical gradients
    result := solver.set_absolute_tolerance (1.0e-8)
                    .set_gradient_step (1.0e-5)
                    .minimize (f, x0)

    -- Numerical gradient: [f(x+eps*e_i) - f(x-eps*e_i)] / (2*eps)
    print ("Gradient norm: " + result.gradient_norm.out)
    print ("Function evals: " + result.function_evaluations.out)
end
```

### Example 4: Ensemble Optimization (SCOOP)

```eiffel
local
    results: ARRAY [OPTIMIZATION_RESULT]
    best_result: OPTIMIZATION_RESULT
    best_f: REAL_64
    i: INTEGER
do
    best_f := REAL_64.max_value

    from i := 1 until i > 100 loop
        -- Each processor runs optimization from different initial point
        results[i] := create {SIMPLE_OPTIMIZATION}.make
                          .create_nelder_mead_solver
                          .minimize (f, random_initial_point)

        -- Results are immutable; safe to aggregate
        if results[i].f_minimum < best_f then
            best_f := results[i].f_minimum
            best_result := results[i]
        end
        i := i + 1
    end

    print ("Best result: f = " + best_result.f_minimum.out)
    print ("Best x = " + best_result.x_minimum[1].out)
end
```

## User-Provided Functions (Agents)

### Objective Function

```eiffel
local
    f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64]
do
    -- Example: Rosenbrock function
    -- f(x) = (1-x₁)² + 100*(x₂-x₁²)²
    create f.make (
        agent (x: ARRAY [REAL_64]): REAL_64
            local
                term1, term2: REAL_64
            do
                term1 := 1.0 - x[1]
                term2 := x[2] - x[1] * x[1]
                Result := term1 * term1 + 100.0 * term2 * term2
            end
    )
end
```

### Analytical Gradient

```eiffel
local
    grad_f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], ARRAY [REAL_64]]
do
    -- Gradient of Rosenbrock function
    -- ∂f/∂x₁ = -2(1-x₁) - 400*x₁*(x₂-x₁²)
    -- ∂f/∂x₂ = 200*(x₂-x₁²)
    create grad_f.make (
        agent (x: ARRAY [REAL_64]): ARRAY [REAL_64]
            local
                grad: ARRAY [REAL_64]
                u: REAL_64
            do
                create grad.make_filled (0.0, 1, 2)
                u := x[2] - x[1] * x[1]
                grad[1] := -2.0 * (1.0 - x[1]) - 400.0 * x[1] * u
                grad[2] := 200.0 * u
                Result := grad
            end
    )
end
```

## Command-Query Separation

| Feature | Type | Modifies? | Returns |
|---------|------|-----------|---------|
| set_absolute_tolerance | Command | YES | like Current |
| set_gradient_function | Command | YES | like Current |
| minimize | Command | YES | OPTIMIZATION_RESULT |
| x_minimum | Query | NO | ARRAY [REAL_64] |
| f_minimum | Query | NO | REAL_64 |
| converged | Query | NO | BOOLEAN |

## Status Queries

| Feature | Returns | Purpose |
|---------|---------|---------|
| iterations | INTEGER | How many steps taken |
| function_evaluations | INTEGER | Total f(x) calls |
| gradient_norm | REAL_64 | ||∇f|| at final point (gradient descent) |
| simplex_diameter | REAL_64 | Nelder-Mead simplex size |
| converged | BOOLEAN | Convergence success |
| convergence_reason | STRING | "tolerance", "max_iterations", "bounds" |

## Immutability Pattern

OPTIMIZATION_RESULT is immutable:
```eiffel
result := solver.minimize (f, x0)

-- Cannot modify result; safe for SCOOP sharing
print (result.f_minimum)    -- OK
x := result.x_minimum
x[1] := 99.0  -- Does not affect result (copy)
```

## Error Handling

No exceptions; contracts enforce validity:
```eiffel
result := solver.minimize (f, x0)

if not result.converged then
    print ("Optimization stopped: " + result.convergence_reason)
else
    process_solution (result.x_minimum)
end
```

## API Consistency

| Pattern | Example | Purpose |
|---------|---------|---------|
| Getter | x_minimum, f_minimum, iterations | Query result |
| Setter | set_tolerance, set_bounds | Configure solver |
| Boolean query | converged | Test success |
| Factory | create_nelder_mead_solver | Create solvers |
| Builder method | Returns like Current | Chain configuration |

## Summary of Public Classes

**SIMPLE_OPTIMIZATION** (facade)
- create_nelder_mead_solver: NELDER_MEAD_SOLVER
- create_gradient_descent_solver: GRADIENT_DESCENT_SOLVER

**NELDER_MEAD_SOLVER** (simplex method)
- set_absolute_tolerance, set_relative_tolerance, set_max_iterations, set_*_bound
- minimize (f, x0): OPTIMIZATION_RESULT

**GRADIENT_DESCENT_SOLVER** (steepest descent)
- set_absolute_tolerance, set_gradient_function, set_gradient_step, set_initial_step_size, set_*_bound, set_max_iterations
- minimize (f, x0): OPTIMIZATION_RESULT

**OPTIMIZATION_RESULT** (immutable results)
- x_minimum: ARRAY [REAL_64]
- f_minimum: REAL_64
- iterations, function_evaluations: INTEGER
- gradient_norm, simplex_diameter: REAL_64
- converged: BOOLEAN
- convergence_reason: STRING
- history: OPTIMIZATION_HISTORY
