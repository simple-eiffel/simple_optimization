# SCOPE: simple_optimization

## Problem Statement
In one sentence: Provide a type-safe, contract-based library for numerical optimization including unconstrained minimization, constrained optimization, and global search methods.

What's wrong today: Optimization problems in Eiffel require external libraries (GSL, COIN-OR) via FFI or manual implementation. Eiffel loses type safety and contract verification. Scientists working on parameter fitting, machine learning, and engineering optimization must leave the language.

Who experiences this: Machine learning practitioners, parameter estimation experts, control engineers, operations researchers, economists modeling optimization problems.

Impact of not solving: Machine learning becomes impractical in Eiffel; parameter fitting requires external tools; optimization-heavy applications choose Python/Julia; research in constrained optimization is lost.

## Target Users
| User Type | Needs | Pain Level |
|-----------|-------|------------|
| ML engineer | Gradient descent, SGD, parameter optimization | HIGH |
| Researcher | Non-convex optimization, global search | HIGH |
| Control engineer | LQR, constrained control optimization | MEDIUM |
| Economist | Equilibrium problems, economic optimization | MEDIUM |
| Statistician | Maximum likelihood estimation (MLE) | HIGH |

## Success Criteria
| Level | Criterion | Measure |
|-------|-----------|---------|
| MVP | Unconstrained 1D minimization | Brent method finds minimum in [a,b] |
| MVP | Multidimensional unconstrained | Nelder-Mead, steepest descent |
| MVP | Gradient-based methods | Gradient descent, conjugate gradient |
| Full | Constrained optimization | Linear/nonlinear constraints (SQP, interior point) |
| Full | Global search | Simulated annealing, genetic algorithms |
| Full | Parameter fitting | Least squares fitting with Jacobian |

## Scope Boundaries
### In Scope (MUST)
- 1D minimization (golden section, Brent's method)
- Multidimensional unconstrained (Nelder-Mead, gradient descent, conjugate gradient)
- Finite difference gradient approximation
- Objective function evaluation with contract guarantees
- Convergence criteria (tolerance, max iterations)
- Optimization result with final value, gradient, iterations

### In Scope (SHOULD)
- User-provided analytical gradients (vs numerical)
- Hessian (second derivative) for Newton methods
- Linear programming (simplex method)
- Nonlinear constrained optimization (penalty methods, SQP)
- Parameter fitting (least squares, curve fitting)
- Global search (simulated annealing, multi-start)

### Out of Scope
- Linear algebra solvers (use simple_linalg when ready)
- Automatic differentiation → simple_autodiff
- Stochastic optimization (SGD with momentum/Adam) → simple_stochastic
- Integer programming / combinatorial optimization → future simple_combinatorial
- Bilevel optimization → too specialized
- Topology optimization → too specialized

### Deferred to Future
- Constrained methods (SQP) → Phase 2
- Global search → Phase 2
- Parameter fitting → Phase 2
- Second-order methods (Newton-Raphson) → Phase 2
- Stochastic methods (SGD) → Phase 3

## Constraints
| Type | Constraint |
|------|------------|
| Technical | Must be void-safe (void_safety="all") |
| Technical | Must be SCOOP-compatible for parallel trials |
| Technical | Gradient computation: analytical or finite-difference |
| Technical | Numerical stability over 1000+ iterations |
| Ecosystem | Must prefer simple_* over ISE libraries |
| Performance | Handle 100+ dimensional problems |
| API | Full Design by Contract with require/ensure/invariant |

## Assumptions to Validate
| ID | Assumption | Risk if False |
|----|------------|---------------|
| A-1 | Optimization is needed in Eiffel community | Medium - could be niche area |
| A-2 | Nelder-Mead and gradient methods sufficient for MVP | Low - well-established methods |
| A-3 | REAL_64 precision adequate for convergence | Low - can use extended precision if needed |
| A-4 | simple_math provides necessary functions | Low - can implement if needed |
| A-5 | Objective functions defined as contracts | Low - fits Eiffel paradigm well |

## Research Questions
- What optimization libraries exist in other languages (SciPy, GSL, NLopt)?
- How do they structure objective functions, gradients, constraints?
- Are there Eiffel optimization implementations?
- What convergence guarantees do standard methods provide?
- How do libraries handle numerical derivatives?
- What are performance expectations for constrained optimization?
- How do successful libraries structure the API (callbacks, objects)?
