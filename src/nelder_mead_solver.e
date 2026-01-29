note
	description: "Nelder-Mead simplex optimization method"
	author: "Larry Rix"

class
	NELDER_MEAD_SOLVER

create
	make

feature {NONE} -- Initialization

	make
			-- Create with default parameters.
		do
			absolute_tolerance := 0.00001
			relative_tolerance := 0.00001
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

	set_relative_tolerance (a_tol: REAL_64): like Current
		do
			relative_tolerance := a_tol
			Result := Current
		ensure
			set: relative_tolerance = a_tol
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
		ensure
			set: lower_bound = a_bound
		end

	set_upper_bound (a_bound: ARRAY [REAL_64]): like Current
		do
			upper_bound := a_bound
			Result := Current
		ensure
			set: upper_bound = a_bound
		end

feature -- Optimization

	minimize (f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64];
			  x0: ARRAY [REAL_64]): OPTIMIZATION_RESULT
			-- Minimize f starting from x0.
		require
			f_not_void: f /= Void
			x0_not_void: x0 /= Void
			x0_not_empty: x0.count > 0
		local
			l_result: OPTIMIZATION_RESULT
		do
			-- Stub: Phase 4 implements Nelder-Mead algorithm
			create l_result.make (x0, x0, 0.0, 0.0, 0, 0, 0.0, 0.0, False, "tolerance", Void)
			Result := l_result
		ensure
			result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	absolute_tolerance: REAL_64
	relative_tolerance: REAL_64
	max_iterations: INTEGER
	lower_bound: detachable ARRAY [REAL_64]
	upper_bound: detachable ARRAY [REAL_64]

end
