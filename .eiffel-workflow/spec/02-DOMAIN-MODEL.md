# DOMAIN MODEL: simple_optimization

## Domain Concepts

### Concept: Objective Function
**Definition:** f(x) = value to minimize, user-provided callback
**Attributes:** Input dimension, output value
**Behaviors:** Evaluate at point x
**Will become:** FUNCTION_CALLBACK

### Concept: Gradient Vector
**Definition:** ∇f = [∂f/∂x₁, ∂f/∂x₂, ..., ∂f/∂xₙ] (optional)
**Attributes:** Direction of steepest ascent
**Behaviors:** Compute numerically or accept analytically
**Will become:** GRADIENT_VECTOR

### Concept: Simplex
**Definition:** Nelder-Mead: n+1 points in n-dimensional space
**Attributes:** Vertex positions, values at each vertex
**Behaviors:** Reflect, expand, contract (algorithm operations)
**Will become:** SIMPLEX

### Concept: Search Direction
**Definition:** Gradient descent: direction -∇f (steepest descent)
**Attributes:** Vector in parameter space
**Behaviors:** Line search along direction
**Will become:** SEARCH_DIRECTION

### Concept: Line Search
**Definition:** Find minimum along 1D ray: min f(x + α * d)
**Attributes:** Current point, direction, step size
**Behaviors:** Compute step size via Armijo condition
**Will become:** LINE_SEARCH

### Concept: Convergence Criterion
**Definition:** When to stop: tolerance on change in x or f
**Attributes:** absolute_tol, relative_tol, max_iterations
**Behaviors:** Check if converged
**Will become:** CONVERGENCE_CHECKER

### Concept: Optimization Result
**Definition:** Final answer and statistics
**Attributes:** x_minimum, f_minimum, iterations, converged
**Behaviors:** Report status, provide result
**Will become:** OPTIMIZATION_RESULT

## Concept Relationships

```
┌──────────────────────────┐
│   Objective Function     │
│   f(x) → REAL_64         │
└───────────┬──────────────┘
            │
      ┌─────┴─────┐
      │           │
      ▼           ▼
GRADIENT VECTOR  SIMPLEX
(analytical)    (Nelder-Mead)
      │           │
      ├─→ SEARCH_DIRECTION
      │           │
      └───────┬───┘
              │
              ▼
         LINE_SEARCH
         (Armijo step)
              │
              ▼
      ┌──────────────────┐
      │ CONVERGENCE_CHK  │
      │ abort if converge│
      └────────┬─────────┘
               │
               ▼
      ┌──────────────────┐
      │ OPTIMIZATION_    │
      │ RESULT (immutable│
      └──────────────────┘
```

## Domain Rules

| Rule | Enforcement |
|------|------------|
| Objective always minimized | Contracts verify f_min is local minimum |
| Tolerance bounds | absolute_tol > 0, relative_tol > 0 |
| Max iterations prevents divergence | max_iterations hard limit |
| Bounds respected | x_min[i] <= result[i] <= x_max[i] |
| Line search finds sufficient decrease | Armijo condition: f(x + α*d) < f(x) - c*α*||∇f||² |
| Nelder-Mead reduces simplex | Simplex volume → 0 as converges |
| Gradient descent monotone decreasing | f(x_k) > f(x_{k+1}) at each iteration |

## Phase 1 Scope

**Included:**
- SIMPLE_OPTIMIZATION facade
- NELDER_MEAD_SOLVER (simplex method)
- GRADIENT_DESCENT_SOLVER (steepest descent)
- Numerical gradient (finite differences)
- Optional analytical gradient
- Variable bounds (box constraints)
- Line search (Armijo backtracking)
- Convergence tolerances and iteration limits
- Statistics (iterations, function evals)

**Deferred to Phase 2:**
- Multi-start global search
- Simulated annealing
- Quasi-Newton (BFGS)
- General constraints (penalty method)
- Second-order methods (Newton)

## Solver Comparison

| Method | Best For | Convergence | Derivatives |
|--------|----------|-------------|-------------|
| Nelder-Mead | Noisy, non-smooth | Slow | None needed |
| Gradient Descent | Smooth, large-scale | Medium | Numerical or analytical |
| (Future) BFGS | Smooth, medium-scale | Fast | Numerical only |
| (Future) Newton | Smooth, well-behaved | Very fast | Numerical and Hessian |

## Algorithm Specifications

### Nelder-Mead (Amoeba)
- **Input:** n+1 vertices (simplex) in ℝⁿ
- **Iteration:** Reflect worst vertex across centroid
- **Operations:** Reflect, expand, contract, shrink
- **Termination:** Simplex size < tolerance
- **Cost:** 1 function eval per iteration (typically)

### Gradient Descent with Line Search
- **Input:** Initial point x₀, tolerance
- **Iteration:** d = -∇f; find step α via Armijo; x = x + α*d
- **Line search:** Halve α until f(x + α*d) < f(x) - c*α*||∇f||²
- **Termination:** ||∇f|| < tolerance or max iterations
- **Cost:** ~ N function evals per iteration (N for gradient)
