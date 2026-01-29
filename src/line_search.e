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
		local
			alpha: REAL_64
			f_new: REAL_64
			backtracks: INTEGER
			l_x_new: ARRAY [REAL_64]
			i: INTEGER
			l_c1: REAL_64
		do
			alpha := 1.0
			backtracks := 0
			l_c1 := 0.0001  -- Armijo constant

			-- Backtracking loop: reduce step size until Armijo condition satisfied
			from until backtracks > 50 loop
				-- Compute x_new = x + alpha * direction
				create l_x_new.make_filled (0.0, x.lower, x.upper)
				from i := x.lower until i > x.upper loop
					l_x_new [i] := x [i] + alpha * direction [i]
					i := i + 1
				end

				-- Evaluate function at new point
				f_new := f.item ([l_x_new])

				-- Check Armijo condition: f(x + alpha*d) <= f(x) + c1*alpha*grad_dot_dir
				if f_new <= f_current + l_c1 * alpha * grad_dot_dir then
					-- Condition satisfied, accept step
					backtracks := 51  -- Exit loop
				else
					-- Condition not satisfied, reduce step size and retry
					alpha := alpha * 0.5
					backtracks := backtracks + 1
				end
			end

			Result := alpha
		ensure
			positive: Result > 0.0
			bounded: Result <= 1.0
		end

end
