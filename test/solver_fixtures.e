note
	description: "Three-tier fixture hierarchy for solver tests (Phase 3 preparation)"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	SOLVER_FIXTURES

inherit
	TEST_SET_BASE

feature -- Tier 1: Default Solvers

	default_nm: NELDER_MEAD_SOLVER
			-- Nelder-Mead solver with default configuration
		once
			create Result.make
		ensure
			solver_created: Result /= Void
		end

	default_gd: GRADIENT_DESCENT_SOLVER
			-- Gradient descent solver with default configuration
		once
			create Result.make
		ensure
			solver_created: Result /= Void
		end

	simple_opt: SIMPLE_OPTIMIZATION
			-- Main optimization facade
		once
			create Result.make
		ensure
			facade_created: Result /= Void
		end

feature -- Tier 2: Configured Solvers (deferred to Phase 4)

	tight_nm: NELDER_MEAD_SOLVER
			-- Nelder-Mead solver with strict convergence criteria
			-- Configuration methods added in Phase 4 when minimize() is implemented
		once
			create Result.make
		ensure
			solver_created: Result /= Void
		end

	bounded_gd: GRADIENT_DESCENT_SOLVER
			-- Gradient descent solver with bounds
			-- Configuration methods added in Phase 4 when minimize() is implemented
		once
			create Result.make
		ensure
			solver_created: Result /= Void
		end

feature -- Tier 3: Specialized Solvers (deferred to Phase 4)

	seeded_nm: NELDER_MEAD_SOLVER
			-- Nelder-Mead with fixed random seed for reproducibility
			-- Seed configuration added in Phase 4
		once
			create Result.make
		ensure
			solver_created: Result /= Void
		end

	adaptive_gd: GRADIENT_DESCENT_SOLVER
			-- Gradient descent with adaptive learning rate
			-- Adaptive configuration added in Phase 4
		once
			create Result.make
		ensure
			solver_created: Result /= Void
		end

feature -- Test Functions (for Phase 4)

	quadratic (x: ARRAY [REAL_64]): REAL_64
			-- Simple quadratic test function: f(x) = x^2 (minimum at x=0, f(0)=0)
		require
			valid_input: x.count >= 1
		do
			Result := x[1] * x[1]
		ensure
			result_non_negative: Result >= 0.0
		end

	rosenbrock (x: ARRAY [REAL_64]): REAL_64
			-- Rosenbrock test function: f(x,y) = (1-x)^2 + 100(y-x^2)^2
			-- Minimum at (1,1), f(1,1)=0
		require
			valid_input: x.count >= 2
		local
			l_a, l_b: REAL_64
		do
			l_a := 1.0 - x[1]
			l_b := x[2] - x[1] * x[1]
			Result := l_a * l_a + 100.0 * l_b * l_b
		ensure
			result_non_negative: Result >= 0.0
		end

end
