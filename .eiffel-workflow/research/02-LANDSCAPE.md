# LANDSCAPE: simple_optimization

## Existing Solutions

### SciPy Optimization (scipy.optimize)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (Python optimization module) |
| Platform | Python (C/Fortran backend) |
| URL | https://docs.scipy.org/doc/scipy/tutorial/optimize.html |
| GitHub | https://github.com/scipy/scipy |
| Maturity | MATURE |
| License | BSD |

**Strengths:**
- Comprehensive: unconstrained, constrained, global optimization
- Multiple algorithms: BFGS, Nelder-Mead, Newton-CG, COBYLA, SLSQP
- User-provided or numerical gradients
- Well-documented with extensive examples
- Active community

**Weaknesses:**
- Python-specific
- Not strongly typed
- Large dependency overhead
- API slightly inconsistent across methods

**Relevance:** 80% - Excellent reference for algorithm selection and API design patterns

---

### Nelder-Mead Algorithm
| Aspect | Assessment |
|--------|------------|
| Type | ALGORITHM (simplex method) |
| Platform | Universal (implemented in many languages) |
| URL | https://en.wikipedia.org/wiki/Nelder%E2%80%93Mead_method |
| SciPy | https://docs.scipy.org/doc/scipy/reference/optimize.minimize-neldermead.html |
| Maturity | CLASSIC (1965) |
| License | Public domain |

**Strengths:**
- Does NOT require gradient computation
- Robust for non-smooth functions
- Simplex-based pattern search
- Works in high dimensions
- Intuitive algorithm

**Weaknesses:**
- Slow convergence (can require many iterations)
- No gradient information used
- Sensitive to initial simplex size

**Relevance:** 85% - Critical for MVP (no gradient required)

---

### GNU Scientific Library (GSL)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (C numerical library) |
| Platform | C/C++ |
| URL | https://www.gnu.org/software/gsl/ |
| GitHub | https://savannah.gnu.org/git/?group=gsl |
| Maturity | MATURE |
| License | GPL |

**Strengths:**
- Comprehensive numerical library
- Includes multimin (Nelder-Mead, BFGS)
- Conjugate gradient methods
- Well-tested

**Weaknesses:**
- GPL license (less commercial-friendly)
- C-specific
- Would require FFI for Eiffel

**Relevance:** 70% - Reference for algorithm implementation

---

### NLopt (Nonlinear Optimization)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (optimization across many solvers) |
| Platform | C with Python, Julia, R, MATLAB bindings |
| URL | https://nlopt.readthedocs.io/ |
| GitHub | https://github.com/stevengj/nlopt |
| Maturity | MATURE |
| License | LGPL/MIT |

**Strengths:**
- Unified interface to many algorithms
- Global and local optimization
- Constrained and unconstrained
- Flexible license
- Active development

**Weaknesses:**
- Wrapper library (not original implementations)
- FFI would be needed for Eiffel
- Complexity

**Relevance:** 75% - Good reference for comprehensive optimization scope

---

### Python Gradient Descent Implementations
| Aspect | Assessment |
|--------|------------|
| Type | ALGORITHM/EXAMPLES (many implementations) |
| Platform | Python |
| URL | https://scipy-lectures.org/advanced/mathematical_optimization/ |
| Maturity | MATURE |
| License | Various |

**Strengths:**
- Clear algorithmic descriptions
- Gradient descent, steepest descent well-documented
- Convergence analysis published

**Weaknesses:**
- Educational rather than production
- Not optimized

**Relevance:** 60% - Good for understanding fundamentals

---

## Eiffel Ecosystem Check

### ISE Libraries
- `base`: ARRAY, LIST (no optimization utilities)
- `math`: sqrt, sin, cos
- No optimization library in ISE

### simple_* Libraries
- `simple_math`: Will provide sqrt, trig - WILL DEPEND
- `simple_linalg`: Will provide matrix operations (future dependency for Hessian)
- **GAP:** No optimization library in Eiffel ecosystem

### Gobo Libraries
- No optimization library in Gobo

### Gap Analysis
**Critical Gap:** Eiffel has NO type-safe optimization library. Practitioners must:
1. FFI to C (GSL, NLopt, or use SciPy)
2. Implement algorithms manually
3. Switch to Python for optimization work

**Opportunity:** simple_optimization fills niche: lightweight, contract-verified, pure Eiffel optimization library. Scientific computing in Eiffel becomes viable.

---

## Comparison Matrix
| Feature | SciPy | GSL | NLopt | Our Need |
|---------|-------|-----|-------|----------|
| Unconstrained 1D | ✓ | ✓ | ✓ | MUST |
| Unconstrained ND | ✓ | ✓ | ✓ | MUST |
| Nelder-Mead | ✓ | ✓ | ✓ | MUST |
| Gradient methods | ✓ | ✓ | ✓ | MUST |
| Linear constraints | ✓ | ✗ | ✓ | SHOULD |
| Nonlinear constraints | ✓ | ✗ | ✓ | SHOULD |
| Global search | ✓ | Partial | ✓ | SHOULD |
| Type-safe contracts | ✗ | ✗ | ✗ | MUST |
| Lightweight | ✗ | ✗ | ✗ | MUST |
| Pure Eiffel | ✗ | ✗ | ✗ | MUST |
| SCOOP compatible | ✗ | ✗ | ✗ | MUST |

---

## Patterns Identified
| Pattern | Seen In | Adopt? |
|---------|---------|--------|
| Single objective function interface | SciPy, GSL, NLopt | YES |
| Convergence criteria (tolerance, max iterations) | All | YES |
| Result object (minimum found, iterations, status) | All | YES |
| Gradient callback (optional vs numerical) | All | YES |
| Bounds specification | SciPy, NLopt | YES |
| Constraint specification | SciPy, NLopt | YES (Phase 2) |
| Hessian callback for Newton methods | SciPy, GSL | YES (Phase 2) |

---

## Build vs Buy vs Adapt
| Option | Effort | Risk | Fit |
|--------|--------|------|-----|
| BUILD | MEDIUM | LOW | 85% - Algorithms well-established, MVP scope clear |
| ADAPT | HIGH | HIGH | 35% - Would require FFI, lose type safety |
| ABANDON | NONE | N/A | 0% - Loses scientific computing credibility |

**Initial Recommendation:** BUILD

**Rationale:** Optimization algorithms are mathematically mature and well-studied. MVP (Nelder-Mead, gradient descent, line search) is achievable. Building allows:
1. Pure Eiffel implementation
2. Type-safe objective function contracts
3. SCOOP support for parallel trials
4. Lightweight library focused on core algorithms
5. Educational value for Eiffel community

---

## References
- SciPy Optimization: https://docs.scipy.org/doc/scipy/tutorial/optimize.html
- Nelder-Mead method: https://en.wikipedia.org/wiki/Nelder%E2%80%93Mead_method
- SciPy minimize reference: https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.minimize.html
- GNU Scientific Library: https://www.gnu.org/software/gsl/
- NLopt: https://nlopt.readthedocs.io/
- SciPy lecture notes: https://scipy-lectures.org/advanced/mathematical_optimization/
- Numerical optimization textbooks: standard references (Nocedal & Wright)
