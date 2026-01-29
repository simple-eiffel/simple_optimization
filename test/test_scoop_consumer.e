note
	description: "SCOOP consumer compatibility test for simple_optimization"

class TEST_SCOOP_CONSUMER

inherit
	EQA_TEST_SET

feature -- Tests

	test_scoop_compatibility
			-- Verify library types work in SCOOP context.
		local
			l_nm: NELDER_MEAD_SOLVER
			l_gd: GRADIENT_DESCENT_SOLVER
		do
			-- Create instances using library's main types
			create l_nm.make
			create l_gd.make

			-- Minimal usage to trigger type checking in SCOOP context
			assert ("nelder-mead created", l_nm /= Void)
			assert ("gradient descent created", l_gd /= Void)
		end

end
