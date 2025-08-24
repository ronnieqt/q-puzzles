/ Tower of Hanoi

/ TODO: how to avoid copying member data for objects?

/ ============================================================
/ Command-line argument(s)

args: .Q.def[([ndisks:4])] .Q.opt .z.x;

/ ============================================================
/ Stack

/ ctor
.stack.init: {[] `long$()};
/ getters
.stack.size: {[data:`J] count data};
.stack.peek: {[data:`J] last data};
/ modifiers
.stack.push: {[data:`J;val:`j] data,val};
.stack.pop : {[data:`J] -1 _ data};
/ ostream
.stack.to_string: {[data:`J] "| "," " sv string data};

/ ============================================================
/ Game

/ ctor
.game.init: {[n:`j]
    stacks: {.stack.init[]} each til 3;
    stacks[0]: stacks[0] .stack.push/ n-1+til n;
    :stacks;
    };
/ modifiers
.game.move_top: {[data;fr;to]
    e: .stack.peek data[fr];
    -1 "... Moving ",string[e]," from stack",string[fr]," to stack",string[to];
    data[fr]: .stack.pop data[fr];
    data[to]: .stack.push[data[to];e];
    -1 .game.to_string data;
    :data;
    };
.game.move_substack: {[data;beg;end;source;target;spare]
    -1 "... Planning to move [",string[beg],"..",string[end],"] from stack",string[source]," to stack",string[target];
    $[beg=end;
        [data: .game.move_top[data;source;target]];
        [data: .z.s[data;beg;end-1;source;spare ;target];
         data: .z.s[data;end;end  ;source;target;spare ];
         data: .z.s[data;beg;end-1;spare ;target;source]]];
    :data;
    };
.game.solve: {[data] .game.move_substack[data;0;.stack.size[data[0]]-1;0;2;1]};
/ ostream
.game.to_string: {[data] "\n" sv {" ",string[x]," ",.stack.to_string y}'[til count data;data]};

/ ============================================================
/ Main

main: {[n]
    game: .game.init[n];
    -1 .game.to_string[game];
    game: .game.solve[game];
    };

main[args`ndisks]; exit 0;

/ ============================================================
