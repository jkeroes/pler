#!/usr/bin/perl

# Test test argument passing capability

use Test::More;
use strict;
use warnings;
use pler;

# install mock
{
    no strict 'refs';
    no warnings 'redefine';
    *{"pler::handoff"} = sub (@) { [@_] };
}

# pler::main() tests
my @tests = (
    [qw{ t/ext/print_args.t                }], [ $^X, '-d', 't/ext/print_args.t'                   ],
    [qw{ t/ext/print_args.t --             }], [ $^X, '-d', 't/ext/print_args.t'                   ],
    [qw{ t/ext/print_args.t -- -f          }], [ $^X, '-d', 't/ext/print_args.t', '-f'             ],
    [qw{ t/ext/print_args.t -- --foo       }], [ $^X, '-d', 't/ext/print_args.t', '--foo'          ],
    [qw{ t/ext/print_args.t -- --foo --    }], [ $^X, '-d', 't/ext/print_args.t', '--foo', '--'    ],
    [qw{ t/ext/print_args.t -- --foo --bar }], [ $^X, '-d', 't/ext/print_args.t', '--foo', '--bar' ],
    [qw{ t/ext/print_args.t -- --foo=foo   }], [ $^X, '-d', 't/ext/print_args.t', '--foo=foo'      ],
    [qw{ t/ext/print_args.t -- --foo 1 2   }], [ $^X, '-d', 't/ext/print_args.t', '--foo', 1, 2    ],
    [qw{ t/ext/print_args.t -- 1 2 --foo   }], [ $^X, '-d', 't/ext/print_args.t', 1, 2, '--foo'    ],
);
plan tests => scalar @tests / 2;

while (my ($argv, $expected) = splice @tests, 0, 2) {
    local @ARGV    = @$argv;
    local $"       = " ";
    my $cmds       = pler::main();

    is_deeply $cmds, $expected, "`pler @ARGV` should run `@$expected`";
}

