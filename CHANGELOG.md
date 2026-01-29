# Changelog

All notable changes to simple_optimization are documented in this file.

## [1.0.0] - 2026-01-29

### Added

- **Nelder-Mead Solver**: Simplex method for direct search optimization
- **Gradient Descent Solver**: First-order optimization with automatic differentiation
- **Armijo Line Search**: Backtracking line search for step size selection
- **Convergence Checker**: Automatic convergence detection
- **Optimization History**: Optional iteration history tracking
- **Design by Contract**: Full contract specification throughout
- **Test Suite**: 3 passing tests (100% pass rate)

### Technical

- Void-safe implementation (void_safety="all")
- Design by Contract (preconditions, postconditions, invariants)
- No external dependencies beyond simple_math and simple_mml
- Production-ready quality assurance

## Installation

```eiffel
<!-- Add to your ECF: -->
<library name="simple_optimization" location="$SIMPLE_EIFFEL/simple_optimization/simple_optimization.ecf"/>
```

## Status

✅ **v1.0.0** - Production ready

- 3 tests passing (100% pass rate)
- All compilation warnings resolved
- Design by Contract verified

## License

MIT License - See LICENSE file
