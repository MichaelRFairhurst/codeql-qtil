/**
 * A module that implements a performance pattern in CodeQL for exploring graphs called
 * forward-reverse pruning.
 * 
 * This pattern is useful for efficiently finding connections between nodes in a directional graph.
 * In a first pass, it finds nodes reachable from the starting point. In the second pass, it finds
 * the subset of those nodes that can be reached from the end point. Together, these create a path
 * from start points to end points.
 * 
 * As with the other performance patterns in qtil, this module may be useful as is, or it may not
 * fit your needs exactly. CodeQL evaluation and performance is very complex. In that case, consider
 * this pattern as an example to create your own solution that fits your needs.
 */
private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.Finalize

/**
 * Implement this signature to utilize forward-reverse pruning on your graph.
 * 
 * ```ql
 * module MyConfig implements ForwardReverseSig<Node> {
 *   predicate start(Node n1) { ... }
 *   predicate edge(Node n1, Node n2) { ... }
 *   predicate end(Node n1) { ... }
 * }
 * ```
 */
signature module ForwardReverseSig<FiniteType Node> {
  /**
   * The nodes that begin the search of the graph.
   * 
   * Ultimately, only paths from a start node to an end node will be found by this module.
   * 
   * In most cases, this will ideally be a smaller set of nodes than the end nodes. However, if the
   * graph branches in one direction more than the other, a larger set which branches less may be
   * preferable.
   * 
   * The design of this predicate has a great effect in how well this performance pattern will
   * ultimately perform.
   */
  predicate start(Node n1);

  /**
   * A directional edge from `n1` to `n2`.
   * 
   * This module will search for paths from `start` to `end` by looking following the direction of
   * these edges.
   * 
   * The design of this predicate has a great effect in how well this performance pattern will
   * ultimately perform.
   */
  predicate edge(Node n1, Node n2);

  /**
   * The end nodes of the search.
   * 
   * Ultimately, only paths from a start node to an end node will be found by this module.
   * 
   * The design of this predicate has a great effect in how well this performance pattern will
   * ultimately perform.
   */
  predicate end(Node n1);
}

/**
 * A module that implements a performance pattern in CodeQL for exploring graphs called
 * forward-reverse pruning.
 * 
 * This pattern is useful for efficiently finding connections between nodes in a directional graph.
 * In a first pass, it finds nodes reachable from the starting point. In the second pass, it finds
 * the subset of those nodes that can be reached from the end point. Together, these create a path
 * from start points to end points.
 * 
 * To use this module, provide an implementation of the `ForwardReverseSig` signature as follows:
 * 
 * ```ql
 * module Config implements ForwardReverseSig<Person> {
 *   predicate start(Person p) { p.checkSomething() }
 *   predicate edge(Person p1, Person p2) { p2 = p1.getAParent() }
 *   predicate end(Person p) { p.checkSomethingElse() }
 * }
 * ```
 * 
 * The design of these predicate has a great effect in how well this performance pattern will
 * ultimately perform.
 * 
 * The resulting predicate `hasPath` should be a much more efficient search of connected start nodes
 * to end nodes than a naive search (which in CodeQL could easily be evaluated as either a full
 * graph search, or a search over the cross product of all nodes).
 * 
 * ```ql
 * from Person p1, Person p2
 * // Fast graph path detection thanks to forward-reverse pruning.
 * where ForwardReverse<Person, Config>::hasPath(p1, p2)
 * select p1, p2
 * ```
 * 
 * The resulting module also exposes two classes:
 * - `ForwardNode`: All nodes reachable from the start nodes.
 * - `ReverseNode`: All forward nodes that reach end nodes.
 * 
 * These classes may be useful in addition to the `hasPath` predicate.
 */
module ForwardReverse<FiniteType Node, ForwardReverseSig<Node> Config> {
  /**
   * The set of all nodes reachable from the start nodes (inclusive).
   * 
   * Note: this is fast to compute because it is essentially a unary predicate.
   */
  class ForwardNode extends Final<Node>::Type {
    ForwardNode() {
      Config::start(this) or
      exists(ForwardNode n | Config::edge(n, this))
    }

    string toString() { result = "ForwardNode" }
  }

  /**
   * The set of all forward nodes that reach end nodes (inclusive).
   * 
   * These nodes are the nodes that exist along the path from start nodes to end nodes.
   * 
   * Note: this is fast to compute because it is essentially a unary predicate.
   */
  class ReverseNode extends ForwardNode {
    ReverseNode() {
      Config::end(this) or
      exists(ReverseNode n | Config::edge(this, n))
    }

    override string toString() { result = "ReverseNode" }
  }

  /**
   * A performant path search from a set of start nodes to a set of end nodes.
   * 
   * This predicate is the main entry point for the forward-reverse pruning pattern.
   * 
   * The design of the config predicates has a great effect in how well this performance pattern
   * will ultimately perform.
   *
   * Example:
   * ```ql
   * from Person p1, Person p2
   * where ForwardReverse<Person, Config>::hasPath(p1, p2)
   * select p1, p2
   * ```
   * 
   * Note: this is fast to compute because limits the search space to nodes found by the fast unary
   * searches done to find `ForwardNode` and `ReverseNode`.
   */
  predicate hasPath(Node n1, Node n2) {
    n1 instanceof ReverseNode and
    n2 instanceof ReverseNode and
    Config::edge(n1, n2)
    or
    exists(ReverseNode nMid |
      hasPath(n1, nMid) and
      Config::edge(nMid, n2)
    )
  }
}
