module Constants
  SENIORITY_TITLES = {
      /staff/ => 'Senior',
      /principal/ => 'Senior',
      /\blead\b/ => 'Senior',
      /senior/ => 'Senior',
      /\biii\b/ => 'Mid-Level',
      /\bii\b/ => 'Mid-Level',
      /mid-?level/ => 'Mid-Level',
      /mid-?weight/ => 'Mid-Level',
      /\bmid\b/ => 'Mid-Level',
      /junior/ => 'Junior',
      /early.?career/ => 'Junior',
      /\bi\b/ => 'Junior',
      /associate/ => 'Junior',
      /[gG]raduate/ => 'Graduate',
      /[gG]rad/ => 'Graduate',
      /[iI]ntern/ => 'Internship'
  }

  SENIORITY_DESCRIPTORS = {
    /track record of/ => 'Junior',
    /(commercial|professional|production|significant) experience(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /proficien(cy|t) (in|with) (?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /deep.{0,28} (knowledge|expertise)(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Mid-Level',
    /experience (in|with).{0,50} (commercial|professional)/ => 'Mid-Level',
    /experience.{3,28} non-internship/ => 'Mid-Level',
    /(mid-level|intermediate).{0,28} (developer|engineer)/ => 'Mid-Level',
    /extensive experience(?!\s*(?:.{0,40}not\s+(?:essential|required)))/ => 'Senior',
    /(seasoned|senior).{0,28} (developer|engineer)/ => 'Senior',
    /expert\b/ => 'Senior'
  }

  JOB_LOCATION_KEYWORDS = [
    /london/,
    /england/,
    /united kingdom/,
    /britain/,
    /\buk\b/,
    /\bemea\b/
  ]

  JOB_LOCATION_FILTER_WORDS = [
    /(full.)?remote/i,
    /hybrid/i,
    /emea/i,
    /location/i,
    %r{\bn/?a\b}i
  ]

  JOB_TITLE_KEYWORDS = [
    /front.?end/,
    /back.?end/,
    /full.?stack/,
    /developer/,
    /programmer/,
    /software/,
    /\bweb\b/,
    /technical lead/,
    /technical support/,
    /technical artist/,
    /development engineer/,
    /product (?:engineer|designer)/,
    /deployed.{1,28}engineer/,
    /data engineer/,
    /research engineer/,
    /prompt engineer/,
    /mobile (?:engineer|developer)/,
    /infrastructure (?:engineer|architect)/,
    /platform (?:engineer|architect)/,
    /security (?:engineer|architect)/,
    /cloud (?:engineer|architect)/,
    /network (?:engineer|architect)/,
    /reliability engineer/,
    /\bsre engineer/,
    /support engineer/,
    /escalation engineer/,
    /test automation engineer/,
    /analytics engineer/,
    /gameplay/,
    /\bui\b/,
    /\bux\b/,
    /\bqa\b/,
    /dev-?ops/,
    /\bios\b/,
    /android/,
    /data scientist/,
    /\bml\b/,
    /\bai\b/,
    /machine learning/,
    /blockchain/,
    /game designer/,
    /low.?latency/,
    /run.?time/,
    /cybersecurity/,
    /threat detection/,
    /malware/,
    /technical designer/,
    /\bseo\b/,
    /ruby/,
    /ruby on rails/,
    /python/,
    /django/,
    /\.net\b/,
    /\bc#/,
    /\bc\+\+/,
    /java/,
    /springboot/,
    /kafka/,
    /distributed systems/,
    /server/,
    /golang/,
    /javascript/,
    /\bjs\b/,
    /nodejs/,
    /\breact\b/,
    /jenkins/,
    /terraform\b/,
    %r{\bci/cd\b},
    /database/,
    /\bsql\b/,
    /workflow automation/,
    /\bapi\b/,
    /data platform/,
    /cloud platform/,
    /cloud ops/,
    /kubernetes/,
    /\baws\b/,
    /google cloud/,
    /\bgcp\b/,
    /linux/,
    /unix/,
    /\btcp\b/
  ]

  CURRENCY_CONVERTER = {
    '$' => ['$', ' USD'],
    '£' => ['£', ' GBP'],
    '€' => ['€', ' EUR'],
    'usd' => ['$', ' USD'],
    'can' => ['$', ' CAN'],
    'aud' => ['$', ' AUD'],
    'gbp' => ['£', ' GBP'],
    'eur' => ['€', ' EUR']
  }
end
