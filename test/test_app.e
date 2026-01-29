note
	description: "Test application runner"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run all tests.
		do
			print ("Running simple_optimization test suite...%N%N")
			passed := 0
			failed := 0

			print ("Optimization Tests%N")
			print ("==================%N")

			-- Test that core classes can be instantiated
			test_simple_optimization
			test_nelder_mead_solver
			test_gradient_descent_solver

			print_summary

			-- Phase 6: Adversarial tests
			create l_adversarial.make
		end

feature {NONE} -- Tests

	test_simple_optimization
			-- Test optimization facade creation.
		local
			l_opt: SIMPLE_OPTIMIZATION
		do
			if not failed_flag then
				create l_opt.make
				passed := passed + 1
				print ("  PASS: test_simple_optimization%N")
			end
		rescue
			failed := failed + 1
			print ("  FAIL: test_simple_optimization%N")
		end

	test_nelder_mead_solver
			-- Test Nelder-Mead solver creation.
		local
			l_solver: NELDER_MEAD_SOLVER
		do
			if not failed_flag then
				create l_solver.make
				passed := passed + 1
				print ("  PASS: test_nelder_mead_solver%N")
			end
		rescue
			failed := failed + 1
			print ("  FAIL: test_nelder_mead_solver%N")
		end

	test_gradient_descent_solver
			-- Test gradient descent solver creation.
		local
			l_solver: GRADIENT_DESCENT_SOLVER
		do
			if not failed_flag then
				create l_solver.make
				passed := passed + 1
				print ("  PASS: test_gradient_descent_solver%N")
			end
		rescue
			failed := failed + 1
			print ("  FAIL: test_gradient_descent_solver%N")
		end

feature {NONE} -- Test Execution

	print_summary
			-- Print test results summary.
		do
			print ("%N====================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")
			print ("Total: " + (passed + failed).out + " tests%N")
			print ("====================%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Implementation

	passed: INTEGER
	failed: INTEGER
	failed_flag: BOOLEAN
	l_adversarial: TEST_ADVERSARIAL

end
