# PARSED REQUIREMENTS: simple_optimization

## Problem Summary
Contract-verified parameter optimization and fitting library for minimizing objective functions. Provides Nelder-Mead simplex and gradient descent methods with line search, optional analytical gradients, and variable bounds. Designed for scientific computing, machine learning parameter fitting, and ensemble optimization via SCOOP.

## Scope

### In Scope
- Univariate minimization on bounded interval [a, b]
- Multivariate minimization (Nelder-Mead, gradient descent)
- Numerical gradient computation (finite differences)
- Optional analytical gradient (user-provided)
- Variable bounds (box constraints)
- Convergence tolerance control
- Maximum iteration limits
- Line search (Armijo backtracking)
- Result with convergence information
- SCOOP-compatible multi-start optimization

### Out of Scope
- Constrained optimization (general constraints) - Phase 2
- Global search (simulated annealing, genetic algorithms) - Phase 2
- Quasi-Newton methods (BFGS) - Phase 2
- Linear programming
- Second-order derivatives (Hessian)

## Functional Requirements
| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|---------------------|
| FR-001 | Minimize 1D function on [a,b] | MUST | Golden section or Brent method correct |
| FR-002 | Minimize multi-variable function | MUST | Nelder-Mead simplex converges |
| FR-003 | Gradient descent optimization | MUST | Steepest descent finds local minimum |
| FR-004 | User provides objective function | MUST | f(x) passed as callback |
| FR-005 | Numerical gradient computation | MUST | Finite differences approximate ∇f |
| FR-006 | User-provided analytical gradient | MUST | User can provide ∇f directly |
| FR-007 | Convergence tolerance | MUST | absolute_tol and relative_tol parameters |
| FR-008 | Maximum iteration limit | MUST | max_iterations prevents infinite loops |
| FR-009 | Result with minimum found | MUST | Returns x_min, f_min, iterations |
| FR-010 | Line search for gradient methods | MUST | Armijo or backtracking line search |
| FR-011 | Bounds specification | SHOULD | Lower and upper bounds on variables |
| FR-012 | Global search (multi-start) | SHOULD | Try multiple initial points (Phase 2) |
| FR-013 | Simulated annealing | SHOULD | Probabilistic global search (Phase 2) |
| FR-014 | Constraint handling | SHOULD | Penalty method for constraints (Phase 2) |

## Non-Functional Requirements
| ID | Requirement | Category | Measure | Target |
|----|-------------|----------|---------|--------|
| NFR-001 | Convergence speed | PERFORMANCE | Iterations to convergence | Reasonable for problem size |
| NFR-002 | Handle high dimensions | PERFORMANCE | Works with 50+ variables | Scales reasonably |
| NFR-003 | Type-safe API | QUALITY | Contract coverage | 100% verified |
| NFR-004 | SCOOP compatible | CONCURRENCY | Multi-start parallel | Safe concurrent trials |
| NFR-005 | No external deps | MAINTAINABILITY | External libs | simple_math only |
| NFR-006 | Void-safe | QUALITY | void_safety | void_safety="all" |
| NFR-007 | Contract coverage | QUALITY | Features contracted | 100% require/ensure |
| NFR-008 | Test coverage | QUALITY | Pass rate | 100% pass, 35+ tests |

## Constraints
| ID | Constraint | Type |
|----|------------|------|
| C-001 | Must be void-safe | TECHNICAL |
| C-002 | Must be SCOOP-compatible | TECHNICAL |
| C-003 | Must use simple_math | ECOSYSTEM |
| C-004 | Only simple_* external | ECOSYSTEM |
| C-005 | All public features contracted | QUALITY |
| C-006 | Zero compilation warnings | TECHNICAL |
| C-007 | REAL_64 precision | TECHNICAL |

## Decisions Already Made
| ID | Decision | Rationale | From |
|----|----------|-----------|------|
| D-001 | Numerical + analytical gradients | Flexibility; users optimize for speed if needed | research/04 |
| D-002 | Unconstrained + bounds only | Bounds common/easy; general constraints Phase 2 | research/04 |
| D-003 | Local methods Phase 1 | Nelder-Mead + gradient descent sufficient; global Phase 2 | research/04 |
| D-004 | Armijo backtracking | Standard, simple, reliable; sufficient for MVP | research/04 |
| D-005 | Separate solver classes | NELDER_MEAD_SOLVER, GRADIENT_DESCENT_SOLVER; each owns tuning | research/04 |

## Innovations to Implement
| ID | Innovation | Design Impact |
|----|------------|---------------|
| I-001 | Contract-verified convergence | Postconditions verify achieved precision |
| I-002 | Pure Eiffel (no FFI) | Type-safe parameter fitting without external C libs |
| I-003 | Parameter fitting focus | Designed from start for curve fitting, ML applications |
| I-004 | SCOOP-ready ensemble | Multi-start trials run concurrently, safe aggregation |

## Risks to Address
| ID | Risk | Mitigation |
|----|------|-----------|
| RISK-001 | Local minima instead of global | Document limitation; Phase 2 adds global search |
| RISK-002 | Ill-conditioned problems | User scaling; documentation; Phase 2 adaptive methods |
| RISK-003 | Numerical gradient inaccuracy | Tunable step size; users provide analytical if needed |
| RISK-004 | Users expect constrained immediately | Clear MVP scope; Phase 2 roadmap clear |
| RISK-005 | Performance on high dimensions | Recommend < 100 variables; gradient descent scales |

## Use Cases

### UC-001: Curve Fitting
**Actor:** Data scientist fitting model parameters
**Precondition:** Data points, model function f(x, params)
**Main Flow:** Minimize squared error between data and model
**Postcondition:** Optimal parameters found

### UC-002: Parameter Optimization
**Actor:** ML engineer tuning hyperparameters
**Precondition:** Objective function (loss)
**Main Flow:** Nelder-Mead simplex search
**Postcondition:** Local minimum found

### UC-003: Ensemble Search (SCOOP)
**Actor:** Parallel optimization engine
**Precondition:** 100 different initial points
**Main Flow:** Each processor runs gradient descent from different start
**Postcondition:** Best minimum found across trials
