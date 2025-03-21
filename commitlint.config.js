module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', ['add', 'update']],
    'scope-enum': [
      2,
      'always',
      [
        'cs',
        'css',
        'dp',
        'env',
        'html',
        'js',
        'linux',
        'next',
        'react',
        'ts',
        'fe-env',
        'cicd',
      ],
    ],
    'scope-empty': [2, 'never'],
  },
};
