/**
 * A module for creating signature predicates without requiring separate declarations.
 *
 * Examples:
 *  - `Nullary::pred/0`: A predicate with no parameters and no result.
 *  - `Nullary::Ret<int>::pred/0`: A predicate with no parameters and an `int` result.
 *  - `Unary<int>::pred/1`: A predicate with one int parameter and no result.
 *  - `Unary<int>::Ret<string>::pred/1`: A predicate with one int parameter and a string result.
 *  - `Binary<int, string>::pred/2`: A predicate with two parameters, an int and a string, and no
 *       result.
 *  - `Binary<int, string>::Ret<int>::pred/2`: A predicate with two parameters, an int and a string,
 *       and an int result.
 *  - `Ternary<A, B, C>::pred/3`: A predicate with three parameters, an `A`, a `B`, and a `C`, and no
 *       result.
 *  - `Ternary<A, B, C>::Ret<D>::pred/3`: A predicate with three parameters, an `A`, a `B`, and a
 *      `C`, and a `D` result.
 *  - etc., for `Quaternary`, `Quinary`, and `Senary` predicates.
 *
 * ## What is the purpose of this module?
 *
 * Creating a parameterized module often requires declaring a signature predicate:
 *
 * ```ql
 * signature predicate isImportant(Foo f);
 * module MyModule<isImportant/1> { ... }
 * ```
 *
 * Sometimes this signature predicate declaration adds clarity, but other times it may feel like
 * boilerplate. Particularly, when the predicate depends on the module's parameters, it requires
 * an additional module declaration.
 *
 * ```ql
 * module PredicateModule<Foo F> {
 *   signature predicate isImportant(F f);
 * }
 *
 * module MyModule<Foo F, PredicateModule<F>::isImportart/1 isImportant> { ... }
 * ```
 *
 * Again, such a declaration may be useful. However, this module provides an option to avoid
 * signature predicate declarations altogether (up to quinary predicates).
 *
 * With this module, you can simply declare:
 *
 * ```ql
 * module MyModule1<Unary<Foo>::pred/1 isImportart> { ... }
 *
 * module MyModule2<Foo F, Unary<F>::pred/1 isImportant> { ... }
 * ```
 */

private import qtil.parameterization.SignatureTypes

/**
 * A module for creating nullary predicates (predicates with no parameters) without requiring a
 * signature predicate declaration.
 *
 * Examples:
 *  - `Nullary::pred/0`: A predicate with no parameters and no result.
 *  - `Nullary::Ret<int>::pred/0`: A predicate with no parameters and an `int` result.
 */
module Nullary {
  /** The resulting signature predicate for this module's type parameters */
  signature predicate pred();

  /**
   * A module for adding a result type to a nullary predicate.
   *
   * Example: `Nullary::Ret<int>::pred/0` is a nullary predicate with an `int` result.
   */
  module Ret<InfiniteType R> {
    /** The resulting signature predicate for this module's type parameters */
    signature R pred();

    /** A signature predicate with no parameters that returns R, with a bindingset on result */
    bindingset[result]
    signature R bindOutput();
  }
}

/**
 * A module for creating unary predicates (predicates with one parameter) without requiring a
 * signature predicate declaration.
 *
 * Examples:
 *  - `Unary<int>::pred/1`: A predicate with one int parameter and no result.
 *  - `Unary<int>::Ret<string>::pred/1`: A predicate with one int parameter and a string result.
 */
module Unary<InfiniteType T> {
  /** The resulting signature predicate for this module's type parameters */
  signature predicate pred(T t);

  /** A signature predicate with one parameter and no result, with a bindingset on the parameter */
  bindingset[t]
  signature predicate bindInput(T t);

  /**
   * A module for adding a result type to a unary predicate.
   *
   * Example: `Unary<int>::Ret<string>::pred/1` is a unary predicate with an int parameter and a
   * string result.
   */
  module Ret<InfiniteType R> {
    /** The resulting signature predicate for this module's type parameters */
    signature R pred(T t);

    /**
     * A signature predicate with one parameter and a result, with a bindingset on the parameter
     *        but not the result
     */
    bindingset[t]
    signature R bindInput(T t);

    /** A signature predicate with one parameter and a result, with a bindingset on the result */
    bindingset[result]
    signature R bindOutput(T t);

    /**
     * A signature predicate with one parameter and a result, with two bindingsets: one for just
     *        the result, and one for just the parameter
     */
    bindingset[result]
    bindingset[t]
    signature R bindInputOutput(T t);
  }
}

/**
 * A module for creating binary predicates (predicates with two parameters) without requiring a
 * signature predicate declaration.
 *
 * Examples:
 *  - `Binary<int, string>::pred/2`: A predicate with two parameters, an int and a string, and no
 *       result.
 *  - `Binary<A, B>::Ret<C>::pred/2`: A predicate with two parameters, an `A` and a `B`, and a
 *       result of type `C`.
 */
module Binary<InfiniteType T1, InfiniteType T2> {
  /** The resulting signature predicate for this module's type parameters */
  signature predicate pred(T1 t1, T2 t2);

  /**
   * A signature predicate with two parameters and no result, with a bindingset on the two
   *      parameters
   */
  bindingset[t1, t2]
  signature predicate bindInput(T1 t1, T2 t2);

  /**
   * A module for adding a result type to a binary predicate.
   *
   * Example: `Binary<A, B>::Ret<C>::pred/2` is a binary predicate with two parameters, an `A` and a
   * `B`, and a result of type `C`.
   */
  module Ret<InfiniteType R> {
    /** The resulting signature predicate for this module's type parameters */
    signature R pred(T1 t1, T2 t2);

    /**
     * A signature predicate with two parameters and a result, with a bindingset on the two
     *        parameters but not the result
     */
    bindingset[t1, t2]
    signature R bindInput(T1 t1, T2 t2);

    /** A signature predicate with two parameters and a result, with a bindingset on the result */
    bindingset[result]
    signature R bindOutput(T1 t1, T2 t2);

    /**
     * A signature predicate with two parameters and a result, with two bindingsets: one for just
     *        the result, and one for just the two parameters
     */
    bindingset[result]
    bindingset[t1, t2]
    signature R bindInputOutput(T1 t1, T2 t2);
  }
}

/**
 * A module for creating ternary predicates (predicates with three parameters) without requiring a
 * signature predicate declaration.
 *
 * Examples:
 *  - `Ternary<A, B, C>::pred/3`: A predicate with three parameters, an `A`, a `B`, and a `C`, and
 *       no result.
 *  - `Ternary<A, B, C>::Ret<D>::pred/3`: A predicate with three parameters, an `A`, a `B`, and a
 *       `C`, and a result of type `D`.
 */
module Ternary<InfiniteType T1, InfiniteType T2, InfiniteType T3> {
  /** The resulting signature predicate for this module's type parameters */
  signature predicate pred(T1 t1, T2 t2, T3 t3);

  /**
   * A signature predicate with three parameters and no result, with a bindingset on the three
   *      parameters
   */
  bindingset[t1, t2, t3]
  signature predicate bindInput(T1 t1, T2 t2, T3 t3);

  /**
   * A module for adding a result type to a ternary predicate.
   *
   * Example: `Ternary<A, B, C>::Ret<D>::pred/3` is a ternary predicate with three parameters, an
   * `A`, a `B`, and a `C`, and a result of type `D`.
   */
  module Ret<InfiniteType R> {
    /** The resulting signature predicate for this module's type parameters */
    signature R pred(T1 t1, T2 t2, T3 t3);

    /**
     * A signature predicate with three parameters and a result, with a bindingset on the three
     *        parameters but not the result
     */
    bindingset[t1, t2, t3]
    signature R bindInput(T1 t1, T2 t2, T3 t3);

    /** A signature predicate with three parameters and a result, with a bindingset on the result */
    bindingset[result]
    signature R bindOutput(T1 t1, T2 t2, T3 t3);

    /**
     * A signature predicate with three parameters and a result, with two bindingsets: one for just
     *        the result, and one for just the three parameters
     */
    bindingset[result]
    bindingset[t1, t2, t3]
    signature R bindInputOutput(T1 t1, T2 t2, T3 t3);
  }
}

/**
 * A module for creating quaternary predicates (predicates with four parameters) without requiring a
 * signature predicate declaration.
 *
 * Examples:
 *  - `Quaternary<A, B, C, D>::pred/4`: A predicate with four parameters, an `A`, a `B`, a `C`, and
 *       a `D`, and no result.
 *  - `Quaternary<A, B, C, D>::Ret<E>::pred/4`: A predicate with four parameters, an `A`, a `B`, a
 *       `C`, and a `D`, and a result of type `E`.
 */
module Quaternary<InfiniteType T1, InfiniteType T2, InfiniteType T3, InfiniteType T4> {
  /** The resulting signature predicate for this module's type parameters */
  signature predicate pred(T1 t1, T2 t2, T3 t3, T4 t4);

  /**
   * A signature predicate with four parameters and no result, with a bindingset on the four
   *      parameters
   */
  bindingset[t1, t2, t3, t4]
  signature predicate bindInput(T1 t1, T2 t2, T3 t3, T4 t4);

  /**
   * A module for adding a result type to a quaternary predicate.
   *
   * Example: `Quaternary<A, B, C, D>::Ret<E>::pred/4` is a quaternary predicate with four
   * parameters, an `A`, a `B`, a `C`, and a `D`, and a result of type `E`.
   */
  module Ret<InfiniteType R> {
    /** The resulting signature predicate for this module's type parameters */
    signature R pred(T1 t1, T2 t2, T3 t3, T4 t4);

    /**
     * A signature predicate with four parameters and a result, with a bindingset on the four
     *        parameters but not the result
     */
    bindingset[t1, t2, t3, t4]
    signature R bindInput(T1 t1, T2 t2, T3 t3, T4 t4);

    /** A signature predicate with four parameters and a result, with a bindingset on the result */
    bindingset[result]
    signature R bindOutput(T1 t1, T2 t2, T3 t3, T4 t4);

    /**
     * A signature predicate with four parameters and a result, with two bindingsets: one for just
     *        the result, and one for just the four parameters
     */
    bindingset[result]
    bindingset[t1, t2, t3, t4]
    signature R bindInputOutput(T1 t1, T2 t2, T3 t3, T4 t4);
  }
}

/**
 * A module for creating quinary predicates (predicates with five parameters) without requiring a
 * signature predicate declaration.
 *
 * Examples:
 *  - `Quinary<A, B, C, D, E>::pred/5`: A predicate with five parameters, an `A`, a `B`, a `C`, a
 *       `D`, and an `E`, and no result.
 *  - `Quinary<A, B, C, D, E>::Ret<F>::pred/5`: A predicate with five parameters, an `A`, a `B`, a
 *       `C`, a `D`, and an `E`, and a result of type `F`.
 */
module Quinary<InfiniteType T1, InfiniteType T2, InfiniteType T3, InfiniteType T4, InfiniteType T5> {
  /** The resulting signature predicate for this module's type parameters */
  signature predicate pred(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);

  /**
   * A signature predicate with five parameters and no result, with a bindingset on the five
   *      parameters
   */
  bindingset[t1, t2, t3, t4, t5]
  signature predicate bindInput(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);

  /**
   * A module for adding a result type to a quinary predicate.
   *
   * Example: `Quinary<A, B, C, D, E>::Ret<F>::pred/5` is a quinary predicate with five parameters,
   * an `A`, a `B`, a `C`, a `D`, and an `E`, and a result of type `F`.
   */
  module Ret<InfiniteType R> {
    /** The resulting signature predicate for this module's type parameters */
    signature R pred(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);

    /**
     * A signature predicate with five parameters and a result, with a bindingset on the five
     *        parameters but not the result
     */
    bindingset[t1, t2, t3, t4, t5]
    signature R bindInput(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);

    /** A signature predicate with five parameters and a result, with a bindingset on the result */
    bindingset[result]
    signature R bindOutput(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);

    /**
     * A signature predicate with five parameters and a result, with two bindingsets: one for just
     *        the result, and one for just the five parameters
     */
    bindingset[result]
    bindingset[t1, t2, t3, t4, t5]
    signature R bindInputOutput(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5);
  }
}

/**
 * A module for creating senary predicates (predicates with six parameters) without requiring a
 * signature predicate declaration.
 *
 * Examples:
 *  - `Senary<A, B, C, D, E, F>::pred/6`: A predicate with six parameters, an `A`, a `B`, a `C`, a
 *       `D`, an `E`, and an `F`, and no result.
 *  - `Senary<A, B, C, D, E, F>::Ret<G>::pred/6`: A predicate with six parameters, an `A`, a `B`, a
 *       `C`, a `D`, an `E`, and an `F`, and a result of type `G`.
 */
module Senary<
  InfiniteType T1, InfiniteType T2, InfiniteType T3, InfiniteType T4, InfiniteType T5,
  InfiniteType T6>
{
  /** The resulting signature predicate for this module's type parameters */
  signature predicate pred(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5, T6 t6);

  /**
   * A signature predicate with six parameters and no result, with a bindingset on the six
   *      parameters
   */
  bindingset[t1, t2, t3, t4, t5, t6]
  signature predicate bindInput(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5, T6 t6);

  module Ret<InfiniteType R> {
    /** The resulting signature predicate for this module's type parameters */
    signature R pred(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5, T6 t6);

    /**
     * A signature predicate with six parameters and a result, with a bindingset on the six
     *        parameters but not the result
     */
    bindingset[t1, t2, t3, t4, t5, t6]
    signature R bindInput(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5, T6 t6);

    /** A signature predicate with six parameters and a result, with a bindingset on the result */
    bindingset[result]
    signature R bindOutput(T1 t1, T2 t2, T3 t3, T4 t4, T5 t5, T6 t6);
  }
}
