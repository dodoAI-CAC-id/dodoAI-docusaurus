import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Docs',
    Svg: null, // No SVG required for the replacement content
    description: (
      <>
        <div>
          <h2>Overview</h2>
          <p>xxxxxxxx</p>
          <pre>
            <code className="language-mermaid">
              {`graph TD;
                A-->B;
                A-->C;
                B-->D;
                C-->D;`}
            </code>
          </pre>
        </div>
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
