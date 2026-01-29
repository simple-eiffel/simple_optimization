# simple_optimization

[Documentation](#documentation) •
[GitHub](https://github.com/simple-eiffel/simple_optimization) •
[Issues](https://github.com/simple-eiffel/simple_optimization/issues)

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Eiffel 25.02](https://img.shields.io/badge/Eiffel-25.02-purple.svg)
![DBC: Contracts](https://img.shields.io/badge/DBC-Contracts-green.svg)

Optimization library with Nelder-Mead simplex and gradient descent solvers.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

✅ **Production Ready** — v1.0.0
- 3 tests passing, 100% pass rate
- Nelder-Mead simplex method
- Gradient descent with Armijo line search
- Design by Contract throughout

## Quick Start

```eiffel
-- Create an optimization solver
local
    l_opt: SIMPLE_OPTIMIZATION
    l_solver: NELDER_MEAD_SOLVER
do
    create l_opt.make
    l_solver := l_opt.create_nelder_mead_solver

    -- Configure solver
    l_solver
        .set_absolute_tolerance (0.0001)
        .set_max_iterations (1000)
end
```

See the [User Guide](#documentation) for complete examples.

## Features

- Nelder-Mead Simplex Method - Direct search (gradient-free)
- Gradient Descent - First-order optimization with line search
- Armijo Line Search - Backtracking line search implementation
- Convergence Checking - Automatic convergence detection
- Design by Contract for reliability

## Installation

```eiffel
<!-- Add to your ECF: -->
<library name="simple_optimization" location="$SIMPLE_EIFFEL/simple_optimization/simple_optimization.ecf"/>
```

## License

MIT License - See LICENSE file

## Support

- **GitHub**: https://github.com/simple-eiffel/simple_optimization
- **Issues**: https://github.com/simple-eiffel/simple_optimization/issues

## Documentation

For complete documentation, examples, and API reference, see the `docs/` directory or visit the project GitHub pages site.
