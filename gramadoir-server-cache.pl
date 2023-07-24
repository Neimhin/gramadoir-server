#!/usr/bin/perl
use lib ".";
use JSON qw( to_json );
use Encode qw( encode decode FB_CROAK LEAVE_SRC );
use Dancer2;
use Lingua::GA::Gramadoir;

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

my $gr = new Lingua::GA::Gramadoir(
	fix_spelling => 1,
	use_ignore_file => 0,
	unigram_tagging => 1,
	interface_language => "en",
	input_encoding => 'utf-8',
);

set serializer => 'JSON';
my $DEFAULT_PORT = 10002;
set port => $ENV{'port'} || $DEFAULT_PORT;

# perl unicode strings to perl unicode strings
# surveyed most common codepoints above 00FF in Tuairisc for this
# below includes everything appearing >= 100 times as of Apr 2018
# (and these are all in thousands!)
sub to_latin1_range {
	(my $txt) = @_;
	for ($txt) {
		s/–/-/g; # U+2013
		s/—/-/g; # U+2014
		s/‘/'/g; # U+2018
		s/’/'/g; # U+2019
		s/“/"/g; # U+201C
		s/”/"/g; # U+201D
		s/…/./g; # U+2026  (want to preserve length for offsets :/)
		s/€/E/g; # U+20AC
		s/\x{0D}\x{0A}/\n/g;  # CGI adds these?
	}
	return $txt;
}

get '/' => sub {
    my ($sentence) = params->{'text'};
    debug $sentence;
    my $errs = $gr->grammatical_errors(encode('UTF-8', to_latin1_range($sentence)));
    # my $errs = $gr->grammatical_errors($sentence);
    my @errs_json;
    foreach my $error (@$errs) {
        (my $fy, my $fx, my $toy, my $tox, my $ruleId, my $msg, my $context, my $contextoffset, my $errorlength) = $error =~ m/^<error fromy="([0-9]+)" fromx="([0-9]+)" toy="([0-9]+)" tox="([0-9]+)" ruleId="([^"]+)" msg="([^"]+)".* context="([^"]+)" contextoffset="([0-9]+)" errorlength="([0-9]+)"\/>$/;
        my $errortext = substr($context,$contextoffset,$errorlength);
        push @errs_json, {'fromy' => $fy,
                            'fromx' => $fx,
                            'toy' => $toy,
                            'tox' => $tox,
                            'ruleId' => $ruleId,
                            'msg' => $msg,
                            'context' => $context,
                            'contextoffset' => $contextoffset,
                            'errorlength' => $errorlength,
                            'errortext' => $errortext,
                        };
    }
    return \@errs_json;
};

start;
