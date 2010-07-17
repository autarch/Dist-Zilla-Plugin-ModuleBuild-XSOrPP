package Dist::Zilla::Plugin::XSOrPPBuild;

use strict;
use warnings;

use Moose;

extends 'Dist::Zilla::Plugin::ModuleBuild';

my $pp_check = <<'EOF';
if ( grep { $_ eq '--pp' } @ARGV ) {
    $build->build_elements(
        [ grep { $_ ne 'xs' } @{ $build->build_elements() } ] );
}

EOF

after setup_installer => sub {
    my $self = shift;

    my ($file) = grep { $_->name() eq 'Build.PL' } @{ $self->zilla()->files() };

    my $content = $file->content();

    $content =~ s/(\$build->create_build_script;)/$pp_check$1/;

    $file->content($content);

    return;
};

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Add a --pp option to your Build.PL to force an XS-less build

__END__

==head1 SYNOPSIS

In your F<dist.ini>:

   [ModuleBuild::XSOrPP]
