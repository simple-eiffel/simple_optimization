note
	description: "Immutable optimization results (SCOOP-safe)"
	author: "Larry Rix"

class
	OPTIMIZATION_RESULT

create
	make

feature {NONE} -- Initialization

	make (a_x_min, a_x_init: ARRAY [REAL_64]; a_f_min, a_f_init: REAL_64;
		  a_iter, a_fevals: INTEGER; a_grad_norm, a_diam: REAL_64;
		  a_converged: BOOLEAN; a_reason: STRING;
		  a_history: detachable OPTIMIZATION_HISTORY)
			-- Create optimization result.
		require
			x_min_not_void: a_x_min /= Void
			x_init_not_void: a_x_init /= Void
			compatible_dimension: a_x_min.count = a_x_init.count
			non_negative_iter: a_iter >= 0
			non_negative_fevals: a_fevals >= 0
		do
			x_minimum := a_x_min
			x_initial := a_x_init
			f_minimum := a_f_min
			f_initial := a_f_init
			iterations := a_iter
			function_evaluations := a_fevals
			gradient_norm := a_grad_norm
			simplex_diameter := a_diam
			converged := a_converged
			convergence_reason := a_reason
			history := a_history
		ensure
			x_min_set: x_minimum = a_x_min
			x_init_set: x_initial = a_x_init
		end

feature -- Access

	x_minimum: ARRAY [REAL_64]
			-- Optimal parameters

	f_minimum: REAL_64
			-- Objective at minimum

	x_initial: ARRAY [REAL_64]
			-- Starting point

	f_initial: REAL_64
			-- Objective at start

	iterations: INTEGER
			-- Number of iterations

	function_evaluations: INTEGER
			-- Total f(x) calls

	gradient_norm: REAL_64
			-- ||∇f|| at final point

	simplex_diameter: REAL_64
			-- Simplex size (Nelder-Mead only)

	converged: BOOLEAN
			-- Success flag

	convergence_reason: STRING
			-- "tolerance", "max_iterations", "bounds"

	dimension: INTEGER
			-- Number of variables
		do
			Result := x_minimum.count
		ensure
			consistent: Result = x_initial.count
		end

	history: detachable OPTIMIZATION_HISTORY
			-- Optional iteration history

invariant
	immutable: True
	x_min_not_void: x_minimum /= Void
	x_init_not_void: x_initial /= Void
	dimensions_match: x_minimum.count = x_initial.count

end
