note
	description: "Test application runner for SIMPLE_OPTIMIZATION"
	author: "Larry Rix with Claude (Anthropic)"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running SIMPLE_OPTIMIZATION tests...%N%N")
			passed := 0
			failed := 0

			print ("-- Tier 1: Solver Creation Tests --%N")
			run_tier_1_tests

			print ("%N-- Tier 2: Solver Fixture Tests --%N")
			run_tier_2_tests

			print ("%N-- Tier 3: Test Function Evaluation --%N")
			run_tier_3_tests

			print ("%N-- Tier 4: Adversarial and SCOOP Tests (port-coordination #17: these ran in no gate) --%N")
			run_tier_4_tests

			print ("%N====================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature -- Test Runners

	run_tier_1_tests
			-- Run Tier 1: Solver creation tests.
		local
			l_tests: LIB_TESTS
		do
			create l_tests
			run_test (agent l_tests.test_nelder_mead_creation, "test_nelder_mead_creation")
			run_test (agent l_tests.test_gradient_descent_creation, "test_gradient_descent_creation")
			run_test (agent l_tests.test_simple_optimization_facade, "test_simple_optimization_facade")
		end

	run_tier_2_tests
			-- Run Tier 2: Solver fixture tests.
		local
			l_tests: LIB_TESTS
		do
			create l_tests
			run_test (agent l_tests.test_tight_nm_creation, "test_tight_nm_creation")
			run_test (agent l_tests.test_bounded_gd_creation, "test_bounded_gd_creation")
			run_test (agent l_tests.test_seeded_nm_creation, "test_seeded_nm_creation")
			run_test (agent l_tests.test_adaptive_gd_creation, "test_adaptive_gd_creation")
		end

	run_tier_4_tests
			-- Run Tier 4: TEST_ADVERSARIAL's edge cases and TEST_SCOOP_CONSUMER's SCOOP check.
		local
			l_adversarial: TEST_ADVERSARIAL
			l_scoop: TEST_SCOOP_CONSUMER
		do
			create l_adversarial
			run_test (agent l_adversarial.test_1d_optimization, "test_1d_optimization")
			run_test (agent l_adversarial.test_high_dimension_optimization, "test_high_dimension_optimization")
			run_test (agent l_adversarial.test_zero_starting_point, "test_zero_starting_point")
			run_test (agent l_adversarial.test_negative_values, "test_negative_values")
			run_test (agent l_adversarial.test_tight_tolerances, "test_tight_tolerances")
			run_test (agent l_adversarial.test_many_iterations, "test_many_iterations")
			run_test (agent l_adversarial.test_config_persistence, "test_config_persistence")
			create l_scoop
			run_test (agent l_scoop.test_scoop_compatibility, "test_scoop_compatibility")
		end

	run_tier_3_tests
			-- Run Tier 3: Test function availability.
		local
			l_tests: LIB_TESTS
		do
			create l_tests
			run_test (agent l_tests.test_quadratic_function_available, "test_quadratic_function_available")
			run_test (agent l_tests.test_rosenbrock_function_available, "test_rosenbrock_function_available")
		end

feature {NONE} -- Implementation

	passed, failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
