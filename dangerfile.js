import {message, danger} from "danger"

var bigPRThreshold = 20;
if (danger.github.pr.additions + danger.github.pr.deletions > bigPRThreshold) {
  fail(':exclamation: PR has more than 500 line changes ');
  markdown('> Pull Request size seems relatively large. If Pull Request contains multiple changes, split each into separate PR will helps faster, easier review.');
}