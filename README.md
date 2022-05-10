
# perl-refactoring-support

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
