# REQUIREMENTS: simple_optimization

## Functional Requirements
| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|---------------------|
| FR-001 | Minimize 1D function on [a,b] | MUST | Golden section or Brent method finds minimum |
| FR-002 | Minimize function of multiple variables | MUST | Nelder-Mead simplex minimization works |
| FR-003 | Gradient descent optimization | MUST | Steepest descent converges to local minimum |
| FR-004 | User provides objective function | MUST | Function passed as agent/callback |
| FR-005 | Numerical gradient computation | MUST | Finite differences compute approximate gradient |
| FR-006 | User-provided analytical gradient | MUST | User can provide df/dx for faster convergence |
| FR-007 | Convergence tolerance | MUST | absolute_tol and relative_tol parameters |
| FR-008 | Maximum iteration limit | MUST | max_iterations prevents infinite loops |
| FR-009 | Result with minimum value found | MUST | Returns x_min, f_min, iterations, status |
| FR-010 | Line search for gradient methods | MUST | Armijo or backtracking line search |
| FR-011 | Bounds specification | SHOULD | Lower and upper bounds on variables |
| FR-012 | Global search (multi-start) | SHOULD | Try multiple initial points, return global minimum |
| FR-013 | Simulated annealing | SHOULD | Probabilistic search for global minima |
| FR-014 | Constraint handling | SHOULD | Penalty method for simple constraints |

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
| ID | Constraint | Type | Immutable? |
|----|------------|------|------------|
| C-001 | Must be void-safe | TECHNICAL | YES |
| C-002 | Must be SCOOP-compatible | TECHNICAL | YES |
| C-003 | Must use simple_math | ECOSYSTEM | YES |
| C-004 | Only simple_* external | ECOSYSTEM | YES |
| C-005 | All public features contracted | QUALITY | YES |
| C-006 | Zero warnings | TECHNICAL | YES |
| C-007 | REAL_64 precision | TECHNICAL | YES |
