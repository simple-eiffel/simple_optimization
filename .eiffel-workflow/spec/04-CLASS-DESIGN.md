# CLASS DESIGN: simple_optimization

## Class Inventory

| Class | Role | Responsibility |
|-------|------|-----------------|
| SIMPLE_OPTIMIZATION | Facade | Entry point, solver creation |
| NELDER_MEAD_SOLVER | Engine | Simplex method iteration |
| GRADIENT_DESCENT_SOLVER | Engine | Steepest descent with line search |
| SIMPLEX | Data | Vertex management for Nelder-Mead |
| GRADIENT_VECTOR | Data | Gradient representation and operations |
| LINE_SEARCH | Engine | Armijo backtracking |
| CONVERGENCE_CHECKER | Engine | Detect convergence conditions |
| OPTIMIZATION_RESULT | Data | Final answer (immutable) |
| OPTIMIZATION_HISTORY | Data | Iteration trajectory (optional) |

## Facade Design: SIMPLE_OPTIMIZATION

**Purpose:** Single entry point for both solvers
**Public Interface:**
```eiffel
class SIMPLE_OPTIMIZATION

create
    make

feature -- Solver Creation

    create_nelder_mead_solver: NELDER_MEAD_SOLVER
    create_gradient_descent_solver: GRADIENT_DESCENT_SOLVER

end
```

## Solver Pattern

Both solvers follow same pattern:
```
1. Configuration phase: set_tolerance, set_max_iterations, set_bounds
2. Execution phase: minimize (f, x0) → OPTIMIZATION_RESULT
3. Result phase: query result for x_min, f_min, iterations
```

## Class Diagram

```
┌──────────────────────────────┐
│  SIMPLE_OPTIMIZATION         │
│  (Facade)                    │
├──────────────────────────────┤
│ + create_nelder_mead_solver  │
│ + create_gradient_descent_.. │
└────────────────┬─────────────┘
                 │
      ┌──────────┴──────────┐
      ▼                     ▼
┌──────────────────┐  ┌──────────────────────┐
│ NELDER_MEAD      │  │ GRADIENT_DESCENT     │
│ SOLVER           │  │ SOLVER               │
├──────────────────┤  ├──────────────────────┤
│ + minimize       │  │ + minimize           │
│ + set_tolerance  │  │ + set_tolerance      │
├──────────────────┤  │ + set_gradient_fn    │
│ - simplex        │  ├──────────────────────┤
└────────┬─────────┘  │ - line_search        │
         │           │ - gradient_vector    │
         │           └────────┬─────────────┘
         │                    │
         ├────────────┬───────┘
         │            │
         ▼            ▼
    ┌────────────────────────────┐
    │  OPTIMIZATION_RESULT       │
    │  (Immutable)               │
    ├────────────────────────────┤
    │ • x_minimum: ARRAY [R64]   │
    │ • f_minimum: REAL_64       │
    │ • iterations: INTEGER      │
    │ • function_evals: INTEGER  │
    │ • converged: BOOLEAN       │
    │ • history: OPTIMIZATION_.. │
    └────────────────────────────┘
```

## Method-Specific Classes

### NELDER_MEAD_SOLVER
- Configuration: Initial simplex size, contraction ratio
- Execution: Reflection, expansion, contraction, shrinkage
- Termination: Simplex diameter < tol

### GRADIENT_DESCENT_SOLVER
- Configuration: Initial step size, gradient function
- Execution: Compute gradient, line search, update
- Termination: ||∇f|| < tol or max iterations

## Helper Classes

### SIMPLEX (Nelder-Mead Data)
- Vertices: n+1 points in ℝⁿ
- Values: f evaluated at each vertex
- Operations: worst, best, centroid, reflect, expand, contract

### GRADIENT_VECTOR
- Components: [∂f/∂x₁, ∂f/∂x₂, ..., ∂f/∂xₙ]
- Operations: magnitude (||∇f||), dot product, scale

### LINE_SEARCH (Armijo)
- Input: Current point, direction, step size
- Output: Accepted step size α
- Condition: f(x + α*d) <= f(x) + c*α*∇f·d

### CONVERGENCE_CHECKER
- Tracks: Function value, gradient norm, simplex size
- Checks: Convergence conditions simultaneously
- Reports: Converged, reason (tol or max_iterations)

## Design Patterns

| Pattern | Where | Rationale |
|---------|-------|-----------|
| Facade | SIMPLE_OPTIMIZATION | Hide solver creation |
| Strategy | {NELDER_MEAD, GRADIENT_DESCENT}_SOLVER | Choose algorithm at runtime |
| Data Transfer | OPTIMIZATION_RESULT | Immutable results for SCOOP |
| Builder | Solver configuration (set_tolerance chains) | Fluent API |

## OOSC2 Compliance

✓ Single Responsibility: Each solver has one algorithm
✓ Open/Closed: Add new solvers (BFGS) without modifying existing
✓ Liskov Substitution: Both solvers inherit from OPTIMIZER base
✓ Interface Segregation: Each solver has focused interface
✓ Dependency Inversion: Depends on function callbacks, not internals

## Eiffel Idioms

- Builder pattern: set_tolerance, set_bounds chains
- Immutable results: OPTIMIZATION_RESULT cannot change after creation
- Agent-based callbacks: f(x) and ∇f(x) passed as agents
- Separate solver classes: Each owns configuration
