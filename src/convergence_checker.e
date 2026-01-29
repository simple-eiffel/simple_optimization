note
	description: "Convergence detection for optimization"
	author: "Larry Rix"

class
	CONVERGENCE_CHECKER

feature -- Convergence

	check_nelder_mead_convergence (diameter, f_max, f_min, tolerance: REAL_64): BOOLEAN
			-- Check Nelder-Mead convergence.
		require
			tolerance_positive: tolerance > 0.0
		do
			Result := (diameter < tolerance) and ((f_max - f_min).abs < tolerance * (f_min.abs + 0.0001))
		end

	check_gradient_convergence (gradient_norm, tolerance: REAL_64): BOOLEAN
			-- Check gradient descent convergence.
		require
			tolerance_positive: tolerance > 0.0
		do
			Result := gradient_norm < tolerance
		end

	should_continue (iterations, max_iterations: INTEGER; converged: BOOLEAN): BOOLEAN
			-- Should optimization continue?
		require
			non_negative_iterations: iterations >= 0
			positive_max: max_iterations > 0
		do
			Result := (iterations < max_iterations) and not converged
		end

end
