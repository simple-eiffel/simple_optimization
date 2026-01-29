note
	description: "Gradient descent with Armijo line search"
	author: "Larry Rix"

class
	GRADIENT_DESCENT_SOLVER

create
	make

feature {NONE} -- Initialization

	make
			-- Create with default parameters.
		do
			absolute_tolerance := 0.00001
			gradient_step := 0.00001
			initial_step_size := 1.0
			max_iterations := 1000
		end

feature -- Configuration

	set_absolute_tolerance (a_tol: REAL_64): like Current
		do
			absolute_tolerance := a_tol
			Result := Current
		ensure
			set: absolute_tolerance = a_tol
		end

	set_gradient_step (eps: REAL_64): like Current
		do
			gradient_step := eps
			Result := Current
		ensure
			set: gradient_step = eps
		end

	set_initial_step_size (a: REAL_64): like Current
		do
			initial_step_size := a
			Result := Current
		ensure
			set: initial_step_size = a
		end

	set_max_iterations (n: INTEGER): like Current
		do
			max_iterations := n
			Result := Current
		ensure
			set: max_iterations = n
		end

	set_lower_bound (a_bound: ARRAY [REAL_64]): like Current
		do
			lower_bound := a_bound
			Result := Current
		end

	set_upper_bound (a_bound: ARRAY [REAL_64]): like Current
		do
			upper_bound := a_bound
			Result := Current
		end

feature -- Optimization

	minimize (f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64];
			  x0: ARRAY [REAL_64]): OPTIMIZATION_RESULT
			-- Minimize f using steepest descent.
		require
			f_not_void: f /= Void
			x0_not_void: x0 /= Void
			x0_not_empty: x0.count > 0
		local
			l_result: OPTIMIZATION_RESULT
			l_x: ARRAY [REAL_64]
			l_x_new: ARRAY [REAL_64]
			l_grad: ARRAY [REAL_64]
			l_direction: ARRAY [REAL_64]
			l_f_current: REAL_64
			l_f_new: REAL_64
			l_grad_norm: REAL_64
			l_grad_dot_dir: REAL_64
			l_alpha: REAL_64
			l_line_search: LINE_SEARCH
			l_iterations: INTEGER
			l_function_evals: INTEGER
			l_status: STRING
			i: INTEGER
		do
			create l_line_search

			l_x := x0
			l_f_current := f.item ([l_x])
			l_iterations := 0
			l_function_evals := 1
			l_status := "converged"

			-- Gradient descent loop
			from until l_iterations > max_iterations loop
				-- Approximate gradient using finite differences
				create l_grad.make_filled (0.0, l_x.lower, l_x.upper)
				from i := l_x.lower until i > l_x.upper loop
					l_x [i] := l_x [i] + gradient_step
					l_grad [i] := (f.item ([l_x]) - l_f_current) / gradient_step
					l_x [i] := l_x [i] - gradient_step
					l_function_evals := l_function_evals + 1
					i := i + 1
				end

				-- Compute gradient norm
				l_grad_norm := 0.0
				from i := l_grad.lower until i > l_grad.upper loop
					l_grad_norm := l_grad_norm + l_grad [i] * l_grad [i]
					i := i + 1
				end
				l_grad_norm := l_grad_norm.sqrt

				-- Check convergence
				if l_grad_norm < absolute_tolerance then
					l_status := "converged"
					l_iterations := max_iterations + 1  -- Exit
				else
					-- Descent direction: -gradient
					create l_direction.make_filled (0.0, l_x.lower, l_x.upper)
					l_grad_dot_dir := 0.0
					from i := l_grad.lower until i > l_grad.upper loop
						l_direction [i] := -l_grad [i]
						l_grad_dot_dir := l_grad_dot_dir - l_grad [i] * l_grad [i]
						i := i + 1
					end

					-- Line search for step size
					l_alpha := l_line_search.compute_step_size (f, l_x, l_direction, l_f_current, l_grad_dot_dir)

					-- Update x
					create l_x_new.make_filled (0.0, l_x.lower, l_x.upper)
					from i := l_x.lower until i > l_x.upper loop
						l_x_new [i] := l_x [i] + l_alpha * l_direction [i]
						i := i + 1
					end

					l_f_new := f.item ([l_x_new])
					l_function_evals := l_function_evals + 1

					-- Check for improvement
					if l_f_new < l_f_current then
						l_x := l_x_new
						l_f_current := l_f_new
					else
						l_status := "stalled"
						l_iterations := max_iterations + 1  -- Exit
					end
				end

				l_iterations := l_iterations + 1
			end

			create l_result.make (x0, l_x, l_f_current, l_grad_norm, l_iterations, l_function_evals, initial_step_size, 0.0, True, l_status, Void)
			Result := l_result
		ensure
			result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	absolute_tolerance: REAL_64
	gradient_step: REAL_64
	initial_step_size: REAL_64
	max_iterations: INTEGER
	lower_bound: detachable ARRAY [REAL_64]
	upper_bound: detachable ARRAY [REAL_64]

end
