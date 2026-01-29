# DECISIONS: simple_optimization

## Decision Log

### D-001: Derivative Requirements
**Question:** Should MVP require user to provide analytical gradients?
**Options:**
1. Analytical only: Requires users to provide df/dx (complex for some)
2. Numerical only: Automatic finite differences (slower)
3. Both: Optional analytical, fallback to numerical

**Decision:** Both (optional analytical, numerical default)
**Rationale:** Provides flexibility; users can optimize for speed if they want
**Implications:** Finite difference computation code, Jacobian callback interface
**Reversible:** YES - can remove analytical path if unused

---

### D-002: Constrained vs Unconstrained
**Question:** Should MVP include constrained optimization?
**Options:**
1. Unconstrained only: Simpler MVP
2. Bounds (box constraints): Simple extension
3. General constraints: Complex, defer to Phase 2

**Decision:** Unconstrained + bounds
**Rationale:** Bounds are common and easy to implement (clipping)
**Implications:** Lower/upper bound specification in solver
**Reversible:** YES - can extend to general constraints in Phase 2

---

### D-003: Global vs Local Search
**Question:** Should MVP include global search methods?
**Options:**
1. Local only: Nelder-Mead, gradient descent
2. Include simple global: Multi-start, simulated annealing
3. Advanced global: Genetic algorithms, etc.

**Decision:** Local for Phase 1, multi-start simple approach
**Rationale:** Local methods sufficient for MVP; global search deferred
**Implications:** Only Nelder-Mead and gradient descent in Phase 1
**Reversible:** NO (global methods would need deeper architecture changes)

---

### D-004: Line Search Strategy
**Question:** How to implement line search for gradient methods?
**Options:**
1. Fixed step size: Simple, unreliable
2. Armijo condition: Standard, proven
3. More complex: Wolfe, etc.

**Decision:** Armijo backtracking
**Rationale:** Standard, simple, reliable; sufficient for MVP
**Implications:** Backtracking loop with halving step size
**Reversible:** YES - can upgrade to Wolfe in Phase 2

---

### D-005: API Design
**Question:** Single minimize function or separate methods?
**Options:**
1. Unified API: scipy.optimize.minimize pattern
2. Separate classes: NelderMead_Solver, GradientDescent_Solver
3. Factory pattern: create_solver("nelder-mead")

**Decision:** Separate solver classes
**Rationale:** Eiffel design pattern; each solver has own tuning parameters
**Implications:** NELDER_MEAD_SOLVER, GRADIENT_DESCENT_SOLVER classes
**Reversible:** YES - can refactor to facade later
