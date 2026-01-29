note
	description: "Optional iteration history for optimization"
	author: "Larry Rix"

class
	OPTIMIZATION_HISTORY

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty history.
		do
			create iterations.make (0)
			create values.make (0)
		ensure
			iterations_empty: iterations.count = 0
			values_empty: values.count = 0
		end

feature -- Access

	iterations: ARRAYED_LIST [ARRAY [REAL_64]]
			-- x values per iteration

	values: ARRAYED_LIST [REAL_64]
			-- f(x) per iteration

feature -- Recording

	add_iteration (x: ARRAY [REAL_64]; f_value: REAL_64)
			-- Record an iteration.
		require
			x_not_void: x /= Void
		do
			iterations.extend (x)
			values.extend (f_value)
		ensure
			count_increased: iterations.count = old iterations.count + 1
		end

invariant
	counts_match: iterations.count = values.count

end
