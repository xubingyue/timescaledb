#ifndef TIMESCALEDB_CHUNK_INSERT_STATE_H
#define TIMESCALEDB_CHUNK_INSERT_STATE_H

#include <postgres.h>
#include <funcapi.h>
#include "chunk.h"
#include "cache.h"

typedef struct ChunkInsertState
{
	Relation	rel;
	ResultRelInfo *result_relation_info;
	Chunk	   *chunk;
} ChunkInsertState;

extern ChunkInsertState *chunk_insert_state_create(Chunk *chunk, EState *estate);
extern void chunk_insert_state_destroy(ChunkInsertState *state);

#endif   /* TIMESCALEDB_CHUNK_INSERT_STATE_H */
