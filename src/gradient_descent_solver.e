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
		do
			-- Stub implementation for Phase 5: just return x0 unchanged
			create l_result.make (x0, x0, 0.0, 0.0, 0, 0, 0.0, 0.0, False, "tolerance", Void)
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
