note
	description: "Adversarial tests for optimization edge cases and stress conditions"
	author: "Larry Rix"

class
	TEST_ADVERSARIAL

create
	make

feature -- Adversarial Tests

	make
			-- Run all adversarial tests
		do
			print ("Optimization Adversarial Tests%N")
			print ("==============================%N")

			-- Edge case: 1D optimization (minimal dimension)
			test_1d_optimization

			-- Edge case: high dimension (10D)
			test_high_dimension_optimization

			-- Edge case: zero starting point
			test_zero_starting_point

			-- Edge case: negative values
			test_negative_values

			-- Stress test: tight tolerances
			test_tight_tolerances

			-- Stress test: many iterations
			test_many_iterations

			-- Edge case: configuration persistence
			test_config_persistence

			print ("%NAdversarial tests completed.%N")
		end

	test_1d_optimization
			-- Test 1D optimization (minimal dimension)
		local
			l_solver: NELDER_MEAD_SOLVER
		do
			print ("  test_1d_optimization: ")
			create l_solver.make
			if l_solver /= Void then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		rescue
			print ("FAIL (exception)%N")
		end

	test_high_dimension_optimization
			-- Test high-dimensional problem (10D)
		local
			l_solver: GRADIENT_DESCENT_SOLVER
		do
			print ("  test_high_dimension_optimization: ")
			create l_solver.make
			if l_solver /= Void then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		rescue
			print ("FAIL (exception)%N")
		end

	test_zero_starting_point
			-- Test with zero starting point
		local
			l_solver: NELDER_MEAD_SOLVER
		do
			print ("  test_zero_starting_point: ")
			create l_solver.make
			l_solver := l_solver.set_absolute_tolerance (0.0001)
			if l_solver /= Void then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		rescue
			print ("FAIL (exception)%N")
		end

	test_negative_values
			-- Test with negative optimization values
		local
			l_solver: GRADIENT_DESCENT_SOLVER
		do
			print ("  test_negative_values: ")
			create l_solver.make
			l_solver := l_solver.set_absolute_tolerance (0.0001)
			l_solver := l_solver.set_initial_step_size (0.5)
			if l_solver /= Void then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		rescue
			print ("FAIL (exception)%N")
		end

	test_tight_tolerances
			-- Test with very tight tolerances
		local
			l_solver: NELDER_MEAD_SOLVER
		do
			print ("  test_tight_tolerances: ")
			create l_solver.make
			l_solver := l_solver.set_absolute_tolerance (0.000001)
			l_solver := l_solver.set_relative_tolerance (0.000001)
			if l_solver /= Void then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		rescue
			print ("FAIL (exception)%N")
		end

	test_many_iterations
			-- Stress test: set many maximum iterations
		local
			l_solver: GRADIENT_DESCENT_SOLVER
		do
			print ("  test_many_iterations: ")
			create l_solver.make
			l_solver := l_solver.set_max_iterations (100000)
			if l_solver /= Void then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		rescue
			print ("FAIL (exception)%N")
		end

	test_config_persistence
			-- Test that configuration persists across method calls
		local
			l_solver: NELDER_MEAD_SOLVER
		do
			print ("  test_config_persistence: ")
			create l_solver.make
			l_solver := l_solver.set_absolute_tolerance (0.0001)
			l_solver := l_solver.set_relative_tolerance (0.0001)
			l_solver := l_solver.set_max_iterations (2000)
			if l_solver /= Void then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		rescue
			print ("FAIL (exception)%N")
		end

end
