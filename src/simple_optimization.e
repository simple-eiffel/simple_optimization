note
	description: "Optimization facade entry point"
	author: "Larry Rix"

class
	SIMPLE_OPTIMIZATION

create
	make

feature {NONE} -- Initialization

	make
			-- Create with default settings.
		do
		ensure
			initialized: True
		end

feature -- Factories

	create_nelder_mead_solver: NELDER_MEAD_SOLVER
			-- Create Nelder-Mead solver.
		do
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

	create_gradient_descent_solver: GRADIENT_DESCENT_SOLVER
			-- Create gradient descent solver.
		do
			create Result.make
		ensure
			result_not_void: Result /= Void
		end

end
