# CONTRACT DESIGN: simple_optimization

## Class Contracts

### NELDER_MEAD_SOLVER

```eiffel
set_absolute_tolerance (a_tol: REAL_64): like Current
    require
        positive_tolerance: a_tol > 0.0
        reasonable: a_tol < 1.0
    ensure
        tolerance_set: absolute_tolerance = a_tol
        result_current: Result = Current

minimize (f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64];
          x0: ARRAY [REAL_64]): OPTIMIZATION_RESULT
    require
        f_not_void: f /= Void
        x0_not_void: x0 /= Void
        x0_not_empty: x0.count > 0
        within_bounds: across x0 as i all
            x0[i.index] >= lower_bound[i.index] and
            x0[i.index] <= upper_bound[i.index]
        end
    ensure
        result_not_void: Result /= Void
        dimension_preserved: Result.x_minimum.count = x0.count
        bounds_respected: across Result.x_minimum as i all
            Result.x_minimum[i.index] >= lower_bound[i.index] and
            Result.x_minimum[i.index] <= upper_bound[i.index]
        end
        simplex_converged: Result.simplex_diameter < absolute_tolerance
        value_converged: abs(Result.f_minimum - f(Result.x_minimum)) < 1.0e-10
```

### GRADIENT_DESCENT_SOLVER

```eiffel
set_gradient_function (a_grad: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], ARRAY [REAL_64]]): like Current
    require
        grad_not_void: a_grad /= Void
    ensure
        gradient_set: gradient_function = a_grad
        result_current: Result = Current

minimize (f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64];
          x0: ARRAY [REAL_64]): OPTIMIZATION_RESULT
    require
        f_not_void: f /= Void
        x0_not_void: x0 /= Void
        x0_not_empty: x0.count > 0
        within_bounds: across x0 as i all
            x0[i.index] >= lower_bound[i.index] and
            x0[i.index] <= upper_bound[i.index]
        end
    ensure
        result_not_void: Result /= Void
        dimension_preserved: Result.x_minimum.count = x0.count
        bounds_respected: across Result.x_minimum as i all
            Result.x_minimum[i.index] >= lower_bound[i.index] and
            Result.x_minimum[i.index] <= upper_bound[i.index]
        end
        gradient_small: Result.gradient_norm < gradient_tolerance
        monotone_decrease: Result.iterations > 0 implies
            f(Result.x_minimum) <= f(x0)
        -- Function value decreased or stayed same
```

### LINE_SEARCH

```eiffel
compute_step_size (x: ARRAY [REAL_64];
                   d: ARRAY [REAL_64];
                   f: FUNCTION [...];
                   grad_f_dot_d: REAL_64): REAL_64
    require
        x_not_void: x /= Void
        d_not_void: d /= Void
        dimension_match: x.count = d.count
        descent_direction: grad_f_dot_d < 0.0
        -- d is descent direction
    ensure
        result_positive: Result > 0.0
        result_bounded: Result <= initial_step_size
        armijo_satisfied: f(x.add(d.scale(Result))) <=
            f(x) + armijo_c * Result * grad_f_dot_d
        -- Sufficient decrease condition
```

### OPTIMIZATION_RESULT

```eiffel
invariant
    x_minimum_not_void: x_minimum /= Void
    x_minimum_not_empty: x_minimum.count > 0
    iterations_non_negative: iterations >= 0
    function_evals_positive: function_evaluations > 0
    f_minimum_consistent: abs(f_minimum - f(x_minimum)) < 1.0e-10
    convergence_consistent: converged implies
        (function_value_change < tol or gradient_norm < tol)
```

## Gradient Computation Contracts

### Numerical Gradient (Finite Differences)

```eiffel
compute_numerical_gradient (f: FUNCTION [...];
                            x: ARRAY [REAL_64];
                            eps: REAL_64): ARRAY [REAL_64]
    require
        f_not_void: f /= Void
        x_not_void: x /= Void
        eps_positive: eps > 0.0
        eps_small: eps < 0.1
    ensure
        gradient_not_void: Result /= Void
        gradient_dimension: Result.count = x.count
        -- Central difference: [f(x+eps*e_i) - f(x-eps*e_i)] / (2*eps)
```

### Analytical Gradient (User-Provided)

```eiffel
user_gradient (x: ARRAY [REAL_64]): ARRAY [REAL_64]
    require
        x_not_void: x /= Void
        x_in_domain: user_domain (x)
    ensure
        result_not_void: Result /= Void
        result_dimension: Result.count = x.count
        result_finite: across Result as g all not g.item.is_nan end
```

## Convergence Specification

**Nelder-Mead:**
```
converged := (simplex_diameter < absolute_tolerance) AND
             (max_value_in_simplex - min_value_in_simplex < relative_tolerance * |min_value|)
```

**Gradient Descent:**
```
converged := (||∇f(x)|| < gradient_tolerance) OR
             (|f(x_k) - f(x_{k-1})| < absolute_tolerance + relative_tolerance * |f(x_{k-1})|) OR
             (iterations >= max_iterations)
```

## Design by Contract Principles

1. **Preconditions:** Function not void, initial point in bounds
2. **Postconditions:** Result point in bounds, convergence achieved
3. **Invariants:** Result dimension matches input; bounds always respected
4. **Frame conditions:** Initial problem (f, bounds) unchanged
5. **Monotonicity:** Gradient descent monotonically decreases

## Error Specification

**Numerical gradient error:**
```
O(eps²) truncation error (central difference)
+ O(eps⁻¹ * machine_epsilon) rounding error
Optimal eps ~ (machine_epsilon)^(1/3) ~ 1e-5 for REAL_64
```

**Convergence guarantee:**
- Nelder-Mead: Simplex volume → 0 (convergence to point)
- Gradient descent: ∇f(x) → 0 (stationary point)
- Neither guarantees global minimum (local search only)
