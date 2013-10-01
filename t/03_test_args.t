#!/usr/bin/perl

# Test test argument passing capability

use strict;
BEGIN {
    $|  = 1;
    $^W = 1;
}

# use Test::More tests => 11;
use Test::More 'no_plan';
use pler;

# install mock
{
    no strict 'refs';

    # local $^W = 0;
    *{"pler::handoff"} = sub { [ @_ ] };
}

# Filter tests
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

while (my ($argv, $expected) = splice @tests, 0, 2) {
    local @ARGV    = @$argv;
    local $"       = " ";
    my $cmds       = pler::main();

    is_deeply $cmds, $expected, "`pler @ARGV` should run `@$expected`";
}

