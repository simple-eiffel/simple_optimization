note
	description: "Armijo backtracking line search"
	author: "Larry Rix"

class
	LINE_SEARCH

feature -- Search

	compute_step_size (f: FUNCTION [ANY, TUPLE [ARRAY [REAL_64]], REAL_64];
					  x: ARRAY [REAL_64]; direction: ARRAY [REAL_64];
					  f_current, grad_dot_dir: REAL_64): REAL_64
			-- Compute step size satisfying Armijo condition.
		require
			f_not_void: f /= Void
			x_not_void: x /= Void
			direction_not_void: direction /= Void
			descent_direction: grad_dot_dir < 0.0
		do
			-- Stub implementation for Phase 5: just return default step size
			Result := 1.0
		ensure
			positive: Result > 0.0
			bounded: Result <= 1.0
		end

end
