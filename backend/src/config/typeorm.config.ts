import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { DataSource, DataSourceOptions } from 'typeorm';
import * as dotenv from 'dotenv';

dotenv.config();

export const getTypeOrmConfig = (
  configService?: ConfigService,
): TypeOrmModuleOptions => {
  const getEnv = (key: string) =>
    configService ? configService.get<string>(key) : process.env[key];

  return {
    type: 'postgres',
    host: getEnv('POSTGRES_HOST'),
    port: parseInt(getEnv('POSTGRES_PORT') || '5432', 10),
    username: getEnv('POSTGRES_USER'),
    password: getEnv('POSTGRES_PASSWORD'),
    database: getEnv('POSTGRES_DATABASE'),
    entities: [__dirname + '/../modules/**/*.entity{.ts,.js}'], // Ajusta la ruta a tus entidades
    synchronize: getEnv('NODE_ENV') !== 'production', // true en desarrollo, false en producción
  };
};

// Exportar un DataSource para la CLI de TypeORM (TypeORM v0.3.x+)
// Esta configuración es la que usará la CLI de TypeORM, por eso lee process.env directamente
// si ConfigService no está disponible en ese contexto.
const dataSourceOptions: DataSourceOptions = {
  type: 'postgres',
  host: process.env.POSTGRES_HOST,
  port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
  username: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DATABASE,
  entities: [__dirname + '/../modules/**/*.entity{.ts,.js}'], // Ajusta la ruta a tus entidades
  synchronize:
    process.env.NODE_ENV !== 'production' &&
    process.env.TYPEORM_SYNCHRONIZE === 'true', // Más control
  // migrationsRun: process.env.NODE_ENV === 'production',
  migrations: [__dirname + '/../typeorm/migrations/*{.ts,.js}'], // Ajusta la ruta
  // logging: true,
};

export const AppDataSource = new DataSource(dataSourceOptions);

// También puedes exportar solo las opciones si prefieres crear el DataSource en otro lado
// export const typeOrmCliConfig = dataSourceOptions;
