
# perl-refactoring-support

## DESCRIPTION

Perl-Critic Policies for simple and isolated Refactoring-Support

This Perl-Crictic Policy-Modules should help where to start a safe refactoring in old leagacy Perl code.

The standard Perl-Critic Policies which can be used are:

* [Perl::Critic::Policy::Modules::ProhibitExcessMainComplexity](https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitExcessMainComplexity)
* [Perl::Critic::Policy::Subroutines::ProhibitExcessComplexity](https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::ProhibitExcessComplexity)

but these are for some bigger scans, so these new Policies should check (or begin) in smaller chunks:

* condition complexity if,while,for (...){}
* subs has many conditionals if,while,for, ...
* large regular Code-Block as statement count
* regular Code-Block complexity {...}
* large Subs as statement count
* return boolean as int

## INSTALLATION

To install this module, run the following commands:

```
  perl Build.PL
  ./Build
  ./Build test
  ./Build install
```

## LICENSE AND COPYRIGHT

This software is copyright (c) 2022 by mardem.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself. The
full text of this license can be found in the LICENSE file included
with this module.
