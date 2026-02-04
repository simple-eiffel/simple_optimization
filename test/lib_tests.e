note
	description: "Configuration and fixture tests for SIMPLE_OPTIMIZATION"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature {NONE} -- Fixtures

	fixtures: SOLVER_FIXTURES
		once
			create Result
		end

feature -- Tier 1: Solver Creation

	test_nelder_mead_creation
			-- Test Nelder-Mead solver creation.
		do
			assert_attached ("nm_created", fixtures.default_nm)
		end

	test_gradient_descent_creation
			-- Test gradient descent solver creation.
		do
			assert_attached ("gd_created", fixtures.default_gd)
		end

	test_simple_optimization_facade
			-- Test main optimization facade creation.
		do
			assert_attached ("facade_created", fixtures.simple_opt)
		end

feature -- Tier 2: Solver Fixtures

	test_tight_nm_creation
			-- Test Nelder-Mead fixture with strict criteria.
		do
			assert_attached ("tight_nm_created", fixtures.tight_nm)
		end

	test_bounded_gd_creation
			-- Test bounded gradient descent fixture.
		do
			assert_attached ("bounded_gd_created", fixtures.bounded_gd)
		end

	test_seeded_nm_creation
			-- Test seeded Nelder-Mead fixture.
		do
			assert_attached ("seeded_nm_created", fixtures.seeded_nm)
		end

	test_adaptive_gd_creation
			-- Test adaptive gradient descent fixture.
		do
			assert_attached ("adaptive_gd_created", fixtures.adaptive_gd)
		end

feature -- Tier 3: Test Function Availability (Phase 4: real evaluation)

	test_quadratic_function_available
			-- Test that quadratic test function is available.
		local
			l_x: ARRAY [REAL_64]
			l_result: REAL_64
		do
			create l_x.make_filled (0.0, 1, 1)
			l_x[1] := 0.0
			l_result := fixtures.quadratic (l_x)
			assert_true ("quadratic_callable", l_result >= 0.0)
		end

	test_rosenbrock_function_available
			-- Test that Rosenbrock test function is available.
		local
			l_x: ARRAY [REAL_64]
			l_result: REAL_64
		do
			create l_x.make_filled (0.0, 1, 2)
			l_x[1] := 1.0
			l_x[2] := 1.0
			l_result := fixtures.rosenbrock (l_x)
			assert_true ("rosenbrock_callable", l_result >= 0.0)
		end

end
